const std = @import("std");

/// SliceIterator is an iterator over a pre-defined slice.
pub fn SliceIterator(comptime T: type) type {
    return struct {
        slice: []const T,
        idx: usize = 0,

        const Self = @This();

        pub fn init(slice: []const T) Self {
            return .{ .slice = slice };
        }

        pub fn next(self: *Self) ?T {
            if (self.idx >= self.slice.len) {
                return null;
            }

            const item = self.slice[self.idx];
            self.idx += 1;
            return item;
        }
    };
}

/// Returns an iterator over a slice.
pub fn fromSlice(comptime T: type, slice: []const T) SliceIterator(T) {
    return SliceIterator(T).init(slice);
}

const hasRead = std.meta.trait.hasFn("readByte");

test "fromSlice" {
    var it = fromSlice(i32, &.{ 1, 2, 3 });
    try std.testing.expect(it.next() == 1);
    try std.testing.expect(it.next() == 2);
    try std.testing.expect(it.next() == 3);
    try std.testing.expect(it.next() == null);
}

/// LineIterator takes a Reader and returns an iterator over its lines.
/// The lines are returned without the newline character.
///
/// LineIterator buffers the Reader internally,
/// so it is safe to use with unbuffered Readers.
///
/// Lines longer than max_line_len will be skipped.
pub fn LineIterator(comptime Reader: type, comptime max_line_len: usize) type {
    std.debug.assert(hasRead(Reader));

    const BufferedReader = std.io.BufferedReader(4096, Reader);

    return struct {
        buf_reader: BufferedReader,
        line_buffer: [max_line_len]u8 = undefined,

        const Self = @This();

        pub fn init(reader: Reader) Self {
            return .{
                .buf_reader = .{ .unbuffered_reader = reader },
            };
        }

        pub fn next(self: *Self) !?[]const u8 {
            var reader = self.buf_reader.reader();
            while (true) {
                var stream = std.io.fixedBufferStream(&self.line_buffer);

                reader.streamUntilDelimiter(
                    stream.writer(),
                    '\n',
                    // It's not necessary to supply the max_line_len here again
                    // since the fixedBufferStream is already limited to that length.
                    null,
                ) catch |err| switch (err) {
                    error.EndOfStream => {
                        // If the stream ends without a newline,
                        // return what was read so far.
                        const written = stream.getWritten();
                        if (written.len > 0) {
                            return written;
                        }
                        return null;
                    },
                    error.NoSpaceLeft => {
                        // If the line is too long, skip it
                        // and try to find the next one.
                        try reader.skipUntilDelimiterOrEof('\n');
                        continue;
                    },
                    else => return err,
                };

                return stream.getWritten();
            }
        }
    };
}

/// Returns an iterator over the lines of a Reader.
/// Lines longer than max_line_len will be skipped.
pub fn lines(
    reader: anytype,
    comptime max_line_len: usize,
) LineIterator(@TypeOf(reader), max_line_len) {
    return LineIterator(@TypeOf(reader), max_line_len).init(reader);
}

test "lines" {
    var buffer = std.io.fixedBufferStream("hello\nworld\n");

    var it = lines(buffer.reader(), 1024);
    try std.testing.expectEqualStrings((try it.next()).?, "hello");
    try std.testing.expectEqualStrings((try it.next()).?, "world");
    try std.testing.expect(try it.next() == null);
}

test "lines: too long" {
    var buffer = std.io.fixedBufferStream("foo\nbarbaz\nqux\n");

    var it = lines(buffer.reader(), 3);
    try std.testing.expectEqualStrings((try it.next()).?, "foo");
    try std.testing.expectEqualStrings((try it.next()).?, "qux");
    try std.testing.expect(try it.next() == null);
}

test "lines: no newline at the end" {
    var buffer = std.io.fixedBufferStream("foo\nbar");
    var it = lines(buffer.reader(), 3);
    try std.testing.expectEqualStrings((try it.next()).?, "foo");
    try std.testing.expectEqualStrings((try it.next()).?, "bar");
    try std.testing.expect(try it.next() == null);
}
