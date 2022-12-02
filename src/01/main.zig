const std = @import("std");
const input = @import("input");

const data = @embedFile("input.txt");

pub fn main() !void {

    //const in = try input.read();

    std.debug.print("{s}", .{data});
}
