const std = @import("std");

const readmeContents = @embedFile("../templates/readme_template.md");
const adrContents = @embedFile("../templates/adr_template.md");

fn replace(comptime T: type, input: []const T, needle: []const T, replacement: []const T) T {
    const replacementSize = std.mem.replacementSize(u8, input, needle, replacement);

    var output = [replacementSize]u8 = undefined;

    std.mem.replace(T, input, needle, replacement, output);

    return output;
}

fn rebuildReadme() !void {
    const f = try std.fs.cwd().createFile("./adr/README.md", .{});

    const max_len = 40;
    var buf: [max_len]u8 = undefined;
    const numAsString = try std.fmt.bufPrint(&buf, "{}", .{std.time.timestamp()});

    var output = replace([]const u8, readmeContents, "{{timestamp}}", std.time.timestamp());
    

    try f.write(output);
}

fn ensureDirsExist() !void {
    const cwd = std.fs.cwd();
    try cwd.makeDir("./adr");
    try cwd.makeDir("./adr/assets");
}

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
