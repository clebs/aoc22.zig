const std = @import("std");

const data = @embedFile("input.txt");

const TOTAL_SPACE = 70_000_000;
const MINIMUM_SPACE = 30_000_000;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit()) std.debug.print("Leak detected!", .{});
    var alloc = gpa.allocator();

    var cmds = std.mem.tokenize(u8, data, "\n");
    var sizes = std.ArrayList(u64).init(alloc);
    defer sizes.deinit();

    var used = try dirSize(&cmds, &sizes);

    const minNeeded = MINIMUM_SPACE - (TOTAL_SPACE - used); // remove free space from minimum needed
    var p1: u64 = 0;
    var p2: u64 = TOTAL_SPACE;
    for (sizes.items) |s| {
        if (s <= 100_000) {
            p1 += s;
        }
        if (s >= minNeeded and s < p2) p2 = s;
    }
    std.debug.print("Size of items under 100.000: {d}\nSmallest item to delete: {d}\n", .{ p1, p2 });
}

fn dirSize(cmds: *std.mem.TokenIterator(u8), sizes: *std.ArrayList(u64)) !u64 {
    var sum: u64 = 0;

    while (cmds.next()) |cmd| {
        if (std.mem.eql(u8, cmd, "$ cd ..")) break;
        const s = if (std.mem.startsWith(u8, cmd, "$ cd")) try dirSize(cmds, sizes) else fileSize(cmd);
        sum += s;
    }
    try sizes.append(sum);
    return sum;
}

fn fileSize(line: []const u8) u64 {
    var info = line[0..std.mem.indexOf(u8, line, " ").?];
    return std.fmt.parseInt(u64, info, 10) catch 0;
}
