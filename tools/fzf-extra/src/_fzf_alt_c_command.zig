//! _fzf_alt_c_command defines the input for the Alt-C shell keybinding in fzf.
//!
//! It lists subdirectories in a Git repository starting at the current directory,
//! falling back to 'find' if the Git yields no results,
//! e.g. because the current directory is git-ignored.

const std = @import("std");
const assert = std.debug.assert;

pub fn main(init: std.process.Init) !void {
    return run(init.io);
}

pub fn run(io: std.Io) !void {
    var stdout_buffer: [4096]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(io, &stdout_buffer);
    defer stdout_writer.interface.flush() catch {};

    const git_dir_count = try listGitDirectories(io, &stdout_writer.interface);
    if (git_dir_count == 0) {
        try listFindDirectories(io, &stdout_writer.interface);
    }
}

/// listGitDirectories lists the subdirectories in a Git repository to the given writer,
/// and returns the total number of directories listed.
pub fn listGitDirectories(io: std.Io, writer: anytype) !usize {
    var child = ChildProcess.initWithChild(io, try std.process.spawn(io, .{
        .argv = &.{ "git", "ls-tree", "-d", "-r", "--name-only", "HEAD" },
        .stdout = .pipe,
        .stderr = .ignore,
    }));
    defer child.deinit();

    var stdout_pipe = child.stdoutPipe();
    var stdout_buffer: [4096]u8 = undefined;
    var stdout_reader = stdout_pipe.reader(io, &stdout_buffer);
    var line_iter = lineIterator(4096, &stdout_reader.interface);
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
pub fn listFindDirectories(io: std.Io, writer: anytype) !void {
    var child = ChildProcess.initWithChild(io, try std.process.spawn(io, .{
        .argv = &.{
            "find", "-L", ".",
            "(", "-path", "*/.*", // ignore hidden
            "-o", "-fstype", "dev", // ignore devices
            "-o",    "-fstype", "proc", // ignore /proc
            ")",     "-prune",  "-o",
            "-type", "d",       "-print",
        },
        .stdout = .pipe,
        .stderr = .ignore,
    }));
    defer child.deinit();

    var stdout_pipe = child.stdoutPipe();
    var stdout_buffer: [4096]u8 = undefined;
    var stdout_reader = stdout_pipe.reader(io, &stdout_buffer);
    var line_iter = lineIterator(4096, &stdout_reader.interface);

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
    io: std.Io,
    child: std.process.Child,
    closed: bool = false,

    /// stdout indicates what to do with the child process's stdout.
    stdout: Output = .ignore,

    /// stderr indicates what to do with the child process's stderr.
    stderr: Output = .ignore,

    /// initWithChild takes ownership of a Child process and wraps it in a ChildProcess.
    /// Caller must still call deinit.
    pub fn initWithChild(io: std.Io, child: std.process.Child) ChildProcess {
        return .{ .io = io, .child = child };
    }

    /// deinit ensures that the child process has been cleaned up.
    pub fn deinit(self: *ChildProcess) void {
        if (self.closed) return;

        self.child.kill(self.io);
    }

    /// stdoutPipe sets up a pipe to the child process's stdout.
    /// The returned pipe may be used once the process has been started.
    pub fn stdoutPipe(self: *ChildProcess) *Output.Pipe {
        const pipe = self.stdout.toPipe();
        self.stdout.takeFile(&self.child.stdout);
        return pipe;
    }

    /// waitOk waits for the child process to exit cleanly,
    /// or it returns an error.
    pub fn waitOk(self: *ChildProcess) !void {
        defer {
            self.closed = true;
        }

        const term = try self.child.wait(self.io);
        switch (term) {
            .exited => |code| if (code != 0) {
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

        fn takeFile(self: *Output, f: *?std.Io.File) void {
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
            file: ?std.Io.File = null,

            pub fn reader(self: *Pipe, io: std.Io, buffer: []u8) std.Io.File.Reader {
                return self.file.?.reader(io, buffer);
            }
        };
    };
};

/// LineIterator iterates over the lines in a Reader,
/// allowing them to be up to `max_len` bytes long.
/// Lines longer than `max_len` are skipped.
fn LineIterator(comptime max_len: usize) type {
    return struct {
        pub const Error = std.Io.Reader.Error;

        reader: *std.Io.Reader,

        const Self = @This();

        /// next returns the next line in the reader,
        /// or null if the reader is exhausted.
        /// The returned line points into the reader's buffer,
        /// and is owned by the iterator.
        pub fn next(self: *Self) Error!?[]const u8 {
            while (true) {
                const line = self.reader.takeDelimiter('\n') catch |err| {
                    switch (err) {
                        error.StreamTooLong => {
                            _ = self.reader.discardDelimiterInclusive('\n') catch |discard_err| {
                                switch (discard_err) {
                                    error.EndOfStream => return null,
                                    error.ReadFailed => return error.ReadFailed,
                                }
                            };
                            continue;
                        },
                        error.ReadFailed => return error.ReadFailed,
                    }
                };
                if (line == null) return null;
                if (line.?.len > max_len) continue;
                return line;
            }
        }
    };
}

/// lineIterator builds a LineIterator over the given Reader value.
pub fn lineIterator(comptime max_len: usize, reader: *std.Io.Reader) LineIterator(max_len) {
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

        var got = std.array_list.Managed([]const u8).init(alloc);
        defer {
            for (got.items) |item| alloc.free(item);
            got.deinit();
        }

        var stream: std.Io.Reader = .fixed(tt.give);
        var iter = lineIterator(10, &stream);
        while (try iter.next()) |line| {
            try got.append(try alloc.dupe(u8, line));
        }

        try std.testing.expectEqualDeep(tt.want, got.items);
    }
}

test "LineIterator long line" {
    const alloc = std.testing.allocator;

    var got = std.array_list.Managed([]const u8).init(alloc);
    defer {
        for (got.items) |item| alloc.free(item);
        got.deinit();
    }

    var stream: std.Io.Reader = .fixed("a\nbc\nd\ne");
    var iter = lineIterator(1, &stream);
    while (try iter.next()) |line| {
        try got.append(try alloc.dupe(u8, line));
    }

    try std.testing.expectEqualDeep(
        @as([]const []const u8, &.{ "a", "d", "e" }),
        got.items,
    );
}
