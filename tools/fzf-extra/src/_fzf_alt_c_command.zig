//! _fzf_alt_c_command defines the input for the Alt-C shell keybinding in fzf.
//!
//! It lists subdirectories in a Git repository starting at the current directory,
//! falling back to 'find' if the Git yields no results,
//! e.g. because the current directory is git-ignored.

const std = @import("std");
const assert = std.debug.assert;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        _ = gpa.deinit();
    }

    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();

    return run(arena.allocator());
}

pub fn run(alloc: std.mem.Allocator) !void {
    var stdout_buffer = std.io.bufferedWriter(std.io.getStdOut().writer());
    defer stdout_buffer.flush() catch {};

    const git_dir_count = try listGitDirectories(alloc, stdout_buffer.writer());
    if (git_dir_count == 0) {
        try listFindDirectories(alloc, stdout_buffer.writer());
    }
}

/// listGitDirectories lists the subdirectories in a Git repository to the given writer,
/// and returns the total number of directories listed.
pub fn listGitDirectories(alloc: std.mem.Allocator, writer: anytype) !usize {
    var child = ChildProcess.initWithChild(std.process.Child.init(
        &.{ "git", "ls-tree", "-d", "-r", "--name-only", "HEAD" },
        alloc,
    ));
    defer child.deinit();

    var stdout_pipe = child.stdoutPipe();

    try child.spawn();

    var stdout_buffer = std.io.bufferedReader(stdout_pipe.reader());
    var line_iter = lineIterator(4096, stdout_buffer.reader());
    var count: usize = 0;
    while (try line_iter.next()) |line| {
        if (std.mem.startsWith(u8, line, "../")) continue;
        if (std.mem.eql(u8, line, "./")) continue;

        try writer.print("{s}\n", .{line});
        count += 1;
    }

    try child.waitOk();
    return count;
}

/// listFindDirectories lists the subdirectories in the current directory using 'find'.
pub fn listFindDirectories(alloc: std.mem.Allocator, writer: anytype) !void {
    var child = ChildProcess.initWithChild(std.process.Child.init(
        &.{
            "find", "-L", ".",
            "(", "-path", "*/.*", // ignore hidden
            "-o", "-fstype", "dev", // ignore devices
            "-o",    "-fstype", "proc", // ignore /proc
            ")",     "-prune",  "-o",
            "-type", "d",       "-print",
        },
        alloc,
    ));
    defer child.deinit();

    var stdout_pipe = child.stdoutPipe();

    try child.spawn();

    var stdout_buffer = std.io.bufferedReader(stdout_pipe.reader());
    var line_iter = lineIterator(4096, stdout_buffer.reader());

    _ = try line_iter.next(); // skip the first line (".")
    while (try line_iter.next()) |find_line| {
        var line = find_line;
        if (std.mem.startsWith(u8, line, "./")) {
            line = line[2..];
        }

        try writer.print("{s}\n", .{line});
    }

    try child.waitOk();
}

/// ChildProcess is a handle to a child process that can be waited on.
/// It provides a more convenient API to clean up the child process:
/// unconditionally defer the deinit method to ensure the process is killed.
///
/// Use the wait method to wait for the process to exit cleanly.
const ChildProcess = struct {
    child: std.process.Child,
    closed: bool = false,

    /// stdout indicates what to do with the child process's stdout.
    stdout: Output = .ignore,

    /// stderr indicates what to do with the child process's stderr.
    stderr: Output = .ignore,

    /// initWithChild takes ownership of a Child process and wraps it in a ChildProcess.
    /// Caller must still call deinit.
    pub fn initWithChild(child: std.process.Child) ChildProcess {
        return .{ .child = child };
    }

    /// deinit ensures that the child process has been cleaned up.
    pub fn deinit(self: *ChildProcess) void {
        if (self.closed) return;

        _ = self.child.kill() catch {};
    }

    /// stdoutPipe sets up a pipe to the child process's stdout.
    /// The returned pipe may be used once the process has been started.
    pub fn stdoutPipe(self: *ChildProcess) *Output.Pipe {
        return self.stdout.toPipe();
    }

    /// spawn starts the child process.
    /// Call waitOk to wait for the process to exit cleanly.
    pub fn spawn(self: *ChildProcess) !void {
        self.stdout.setStdIoBehavior(&self.child.stdout_behavior);
        self.stderr.setStdIoBehavior(&self.child.stderr_behavior);

        try self.child.spawn();

        self.stdout.takeFile(&self.child.stdout);
        self.stderr.takeFile(&self.child.stderr);
    }

    /// waitOk waits for the child process to exit cleanly,
    /// or it returns an error.
    pub fn waitOk(self: *ChildProcess) !void {
        defer {
            self.closed = true;
        }

        const term = try self.child.wait();
        switch (term) {
            .Exited => |code| if (code != 0) {
                return error.NonZeroStatus;
            },
            else => return error.UnexpectedTermination,
        }
    }

    pub const Output = union(enum) {
        /// ignore indicates that the output should be ignored.
        ignore,

        /// inherit indicates that the output should be sent
        /// to the parent process's output stream.
        inherit,

        /// pipe indicates that the output should be piped to the parent process.
        /// A Reader is made available to read the output.
        pipe: Pipe,

        /// Converts this output stream to a pipe.
        fn toPipe(self: *Output) *Pipe {
            assert(self.* != .pipe); // already a pipe
            self.* = .{ .pipe = .{} };
            return &self.pipe;
        }

        fn setStdIoBehavior(self: *Output, std_stream: *std.process.Child.StdIo) void {
            switch (self.*) {
                .pipe => std_stream.* = .Pipe,
                .ignore => std_stream.* = .Ignore,
                .inherit => std_stream.* = .Inherit,
            }
        }

        fn takeFile(self: *Output, f: *?std.fs.File) void {
            switch (self.*) {
                .pipe => |*pipe| {
                    pipe.file = f.* orelse unreachable;
                    // null out the file so that Child.Process does not attempt to close it.
                    // We own it now.
                    f.* = null;
                },
                else => {},
            }
        }

        /// Pipe provides access to the output of a child process.
        pub const Pipe = struct {
            /// File is the file descriptor for the output of the child process.
            /// This is null until the child process is started.
            file: ?std.fs.File = null,

            pub fn reader(self: *Pipe) std.fs.File.Reader {
                return self.file.?.reader();
            }
        };
    };
};

/// LineIterator iterates over the lines in a Reader,
/// allowing them to be up to `max_len` bytes long.
/// Lines longer than `max_len` are skipped.
fn LineIterator(comptime max_len: usize, Reader: type) type {
    return struct {
        pub const Error = Reader.Error;

        buffer: [max_len]u8 = undefined,
        reader: Reader,

        const Self = @This();

        /// next returns the next line in the reader,
        /// or null if the reader is exhausted.
        /// The returned line points to an internal buffer,
        /// and is owned by the iterator.
        pub fn next(self: *Self) Error!?[]const u8 {
            while (true) {
                var buffer_stream = std.io.fixedBufferStream(&self.buffer);
                self.reader.streamUntilDelimiter(buffer_stream.writer(), '\n', null) catch |err| {
                    switch (err) {
                        error.StreamTooLong, error.NoSpaceLeft => {
                            // skip long lines
                            try self.reader.skipUntilDelimiterOrEof('\n');
                            continue;
                        },
                        error.EndOfStream => if (buffer_stream.getWritten().len == 0) return null,
                        else => return @as(Error, @errorCast(err)),
                    }
                };
                return buffer_stream.getWritten();
            }
        }
    };
}

/// lineIterator builds a LineIterator over the given Reader value.
pub fn lineIterator(comptime max_len: usize, reader: anytype) LineIterator(max_len, @TypeOf(reader)) {
    return .{ .reader = reader };
}

test "LineIterator" {
    const tests = [_]struct {
        give: []const u8,
        want: []const []const u8,
    }{
        .{
            .give = "a\nb\nc\n",
            .want = &.{ "a", "b", "c" },
        },
        .{
            .give = "a\n\nb\nc",
            .want = &.{ "a", "", "b", "c" },
        },
    };

    for (tests) |tt| {
        const alloc = std.testing.allocator;

        var got = std.ArrayList([]const u8).init(alloc);
        defer {
            for (got.items) |item| alloc.free(item);
            got.deinit();
        }

        var stream = std.io.fixedBufferStream(tt.give);
        var iter = lineIterator(10, stream.reader());
        while (try iter.next()) |line| {
            try got.append(try alloc.dupe(u8, line));
        }

        try std.testing.expectEqualDeep(tt.want, got.items);
    }
}

test "LineIterator long line" {
    const alloc = std.testing.allocator;

    var got = std.ArrayList([]const u8).init(alloc);
    defer {
        for (got.items) |item| alloc.free(item);
        got.deinit();
    }

    var stream = std.io.fixedBufferStream("a\nbc\nd\ne");
    var iter = lineIterator(1, stream.reader());
    while (try iter.next()) |line| {
        try got.append(try alloc.dupe(u8, line));
    }

    try std.testing.expectEqualDeep(
        @as([]const []const u8, &.{ "a", "d", "e" }),
        got.items,
    );
}
