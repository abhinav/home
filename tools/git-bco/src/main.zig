//! git-bco is a convenience script for checking out a branch.
//!
//! Usage:
//!
//!     git bco [options] [branch]
//!
//! It spawns an fzf-based selector for branches.
//! If `branch` is specified, it forms the initial query for fzf.
//!
//! Options are passed to `git checkout` as-is.

const std = @import("std");
const Args = @import("Args.zig");
const iter = @import("iter.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var alloc = arena.allocator();

    run(alloc) catch |err| switch (err) {
        error.Explained => std.os.exit(1),
        else => return err,
    };
}

pub fn run(alloc: std.mem.Allocator) !void {
    var args_iter = try std.process.argsWithAllocator(alloc);
    defer args_iter.deinit();

    _ = args_iter.next() orelse unreachable; // skip program name
    var args = try Args.parse(alloc, &args_iter);
    defer args.deinit();

    const branch = selectBranch(alloc, args.branch, args.detach) catch |err| {
        switch (err) {
            error.NoLocalBranches => {
                std.log.err("no local branches", .{});
                return error.Explained;
            },
            else => return err,
        }
    };
    // Need to free only if we used selectBranch.
    defer if (args.branch == null) alloc.free(branch);

    return checkout(alloc, branch, args.options);
}

// selectBranch spawns an fzf-based selector to select from local branches.
// The selected branch is returned.
//
// The caller must free the returned slice.
fn selectBranch(alloc: std.mem.Allocator, init_branch: ?[]const u8, detach: bool) ![]const u8 {
    var git_branch = std.ChildProcess.init(&.{ "git", "branch" }, alloc);
    git_branch.stdout_behavior = .Pipe;
    try git_branch.spawn();
    errdefer {
        // Ignore errors from killing the child process,
        // e.g. if it has already exited.
        _ = git_branch.kill() catch {};
    }

    // Ensure that there is at least one local branch that we can select
    // before we spawn fzf.
    // Otherwise, we would end up with an empty fzf window.
    var git_branch_stdout = git_branch.stdout orelse unreachable;
    var local_branches = localBranchIterator(iter.lines(git_branch_stdout.reader(), 256));
    local_branches.checked_out = detach;

    const first_branch = try local_branches.next() orelse {
        // If Git exited with a non-zero status,
        // we can't be sure that there are no local branches.
        try checkTerm("git branch", try git_branch.wait());
        return error.NoLocalBranches;
    };

    var fzf_args: []const []const u8 = &.{
        "fzf",
        "--height=30%",
        "--prompt=Branch> ",
        "--preview=git log --color --oneline {} ^$(git merge-base HEAD {})",
    };
    if (init_branch) |b| {
        fzf_args = try std.mem.concat(alloc, []const u8, &.{ fzf_args, &.{ "--query", b } });
    }
    defer if (init_branch != null) alloc.free(fzf_args);

    var fzf = std.ChildProcess.init(fzf_args, alloc);
    fzf.stdout_behavior = .Pipe;
    fzf.stdin_behavior = .Pipe;
    try fzf.spawn();
    errdefer {
        // Ignore errors from killing the child process,
        // e.g. if it has already exited.
        _ = fzf.kill() catch {};
    }

    // Pipe branch names from git branch to fzf,
    // but only for branches not currently checked out.
    {
        var fzf_stdin = fzf.stdin orelse unreachable;
        defer {
            fzf_stdin.close();

            // HACK:
            // Calling wait() with a closed ChildProcess.stdin
            // causes a panic.
            // Replace stdin with null to avoid this.
            fzf.stdin = null;
        }

        var fzf_write_buffer = std.io.bufferedWriter(fzf_stdin.writer());
        defer fzf_write_buffer.flush() catch |err| {
            std.log.err("error flushing fzf stdin: {}", .{err});
        };
        var fzf_writer = fzf_write_buffer.writer();

        try fzf_writer.print("{s}\n", .{first_branch});
        while (try local_branches.next()) |branch| {
            try fzf_writer.print("{s}\n", .{branch});
        }

        // Wait for git branch to exit before closing fzf stdin.
        // This means we fed all branches to fzf before before closing it.
        try checkTerm("git branch", try git_branch.wait());
    }

    var buf = try std.ArrayList(u8).initCapacity(alloc, 256);
    defer buf.deinit();
    var fzf_stdout = fzf.stdout orelse unreachable;
    try fzf_stdout.reader().readAllArrayList(&buf, 256);

    try checkTerm("fzf", try fzf.wait());
    return strip(try buf.toOwnedSlice());
}

/// checkout checks out the given branch with the given options.
fn checkout(alloc: std.mem.Allocator, branch: []const u8, options: []const []const u8) !void {
    const checkout_args_buffer = [_][]const u8{ "git", "checkout", branch };

    var args: []const []const u8 = undefined;
    if (options.len == 0) {
        // Optimization: If there are no options, we can avoid allocating.
        args = checkout_args_buffer[0..];
    } else {
        args = try std.mem.concat(alloc, []const u8, &.{ checkout_args_buffer[0..], options });
    }
    defer if (options.len != 0) alloc.free(args);

    var git_checkout = std.ChildProcess.init(args, alloc);
    try checkTerm("git checkout", try git_checkout.spawnAndWait());
}

/// LocalBranchIterator is an iterator that yields local branch names,
/// reading from the given iterator of lines from `git branch`.
fn LocalBranchIterator(comptime Iter: type) type {
    if (!std.meta.trait.hasFn("next")(Iter)) {
        @compileError("Reader must implement next() !?[]const u8");
    }

    return struct {
        /// Iterator of lines from `git branch`.
        iter: Iter,

        /// Whether to include branches that are currently checked out
        /// in this or other worktrees.
        checked_out: bool = false,

        /// Returns the next local branch name.
        /// Returns null if there are no more local branches.
        pub fn next(self: *@This()) !?[]const u8 {
            while (true) {
                var line = try self.iter.next() orelse return null;
                var name = strip(line);
                if (name.len == 0) continue;

                switch (name[0]) {
                    '(' => continue, // "(HEAD detached at ...)".
                    '*', '+' => {
                        if (!self.checked_out) {
                            // Skip branches checked out in this or other worktrees.
                            continue;
                        }

                        return strip(name[1..]);
                    },
                    else => return name,
                }
            }
        }
    };
}

/// Builds a LocalBranchIterator from an iterator of lines from `git branch`.
pub fn localBranchIterator(i: anytype) LocalBranchIterator(@TypeOf(i)) {
    return LocalBranchIterator(@TypeOf(i)){
        .iter = i,
    };
}

/// checkTerm checks that a child process terminated successfully.
fn checkTerm(
    comptime name: []const u8,
    term: std.ChildProcess.Term,
) !void {
    switch (term) {
        .Exited => |code| if (code != 0) {
            std.log.err("{s} exited with code {}", .{ name, code });
            return error.Explained;
        },
        else => {
            std.log.err("{s} terminated abnormally", .{name});
            return error.Explained;
        },
    }
}

/// strips leading and trailing whitespace and newlines from a slice.
fn strip(s: []const u8) []const u8 {
    return std.mem.trim(u8, s, "\n \t");
}

test {
    std.testing.refAllDecls(@This());
}
