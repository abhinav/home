//! Defines the command line arguments for the application.

const std = @import("std");
const iter = @import("iter.zig");

alloc: std.mem.Allocator,

/// Buffer holding the combined contents of all arguments.
/// branch and options are slices into this buffer.
buffer: []const u8,

/// The branch to check out, if specified.
branch: ?[]const u8,

// Whether the checkout request is for a detached HEAD.
// If true, we can list checked-out branches as well.
detach: bool = false,

/// Options to pass to `git checkout`.
options: []const []const u8,

const Self = @This();

/// Parses arguments from the given iterator.
/// The iterator must have already consumed the program name.
///
/// The returned object must be freed with `deinit`.
pub fn parse(alloc: std.mem.Allocator, args_iter: anytype) error{OutOfMemory}!Self {
    var buffer = std.ArrayList(u8).init(alloc);
    defer buffer.deinit();

    var branch: ?[]const u8 = null;
    var options = std.ArrayList([]const u8).init(alloc);
    var detached = false;
    defer options.deinit();

    while (args_iter.next()) |arg| {
        const start_idx = buffer.items.len;
        try buffer.appendSlice(arg);
        const owned_arg = buffer.items[start_idx..];

        if (std.mem.startsWith(u8, arg, "-")) {
            detached = detached or std.mem.eql(u8, arg, "--detach");
            try options.append(owned_arg);
        } else {
            branch = owned_arg;
        }
    }

    return .{
        .alloc = alloc,
        .buffer = try buffer.toOwnedSlice(),
        .branch = branch,
        .detach = detached,
        .options = try options.toOwnedSlice(),
    };
}

/// Frees the memory allocated by `parse`.
pub fn deinit(self: *Self) void {
    self.alloc.free(self.options);
    self.branch = null; // owned by self.buffer
    self.alloc.free(self.buffer);
}

test "parse with branch" {
    var alloc = std.testing.allocator;

    var args_iter = iter.fromSlice([]const u8, &.{ "-v", "foo" });

    var args = try Self.parse(alloc, &args_iter);
    defer args.deinit();

    try std.testing.expectEqualStrings("foo", args.branch orelse unreachable);

    try std.testing.expectEqual(@as(usize, 1), args.options.len);
    try std.testing.expectEqualStrings("-v", args.options[0]);
}

test "Args.parse no branch" {
    var alloc = std.testing.allocator;

    var args_iter = iter.fromSlice([]const u8, &.{ "--depth=1", "--verbose" });

    var args = try Self.parse(alloc, &args_iter);
    defer args.deinit();

    try std.testing.expect(args.branch == null);
    try std.testing.expectEqual(@as(usize, 2), args.options.len);
    try std.testing.expectEqualStrings("--depth=1", args.options[0]);
    try std.testing.expectEqualStrings("--verbose", args.options[1]);
}
