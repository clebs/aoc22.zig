const std = @import("std");

const data = @embedFile("input.txt");

fn initStacks(alloc: std.mem.Allocator) [9]std.ArrayList(u8) {
    var stacks: [9]std.ArrayList(u8) = undefined;
    var i: usize = 0;
    while (i < 9) : (i += 1) {
        stacks[i] = std.ArrayList(u8).init(alloc);
    }
    return stacks;
}

fn deinitStacks(stacks: []std.ArrayList(u8)) void {
    for (stacks) |s| {
        s.deinit();
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit()) std.debug.print("Leak detected!", .{});
    var alloc = gpa.allocator();

    var stacks = initStacks(alloc);
    defer deinitStacks(&stacks);
    // read input
    var index = std.mem.indexOf(u8, data, "\n\n").?;
    // build stacks
    var stackIt = std.mem.splitBackwards(u8, data[0..index], "\n");
    _ = stackIt.next();

    const ITEM_OFFSET: u8 = 4;
    while (stackIt.next()) |line| {
        if (line.len == 0) continue;

        var i: u8 = 0;
        while (i < 9) : (i += 1) {
            var pos: u8 = i * ITEM_OFFSET + 1;
            if (line[pos] != ' ') try stacks[i].append(line[pos]);
        }
    }

    // process instructions
    var instructions = std.mem.split(u8, data[index..], "\n");

    var buf: [50]u8 = undefined;
    while (instructions.next()) |instruction| {
        if (instruction.len == 0) continue;
        var w = std.mem.split(u8, instruction, " ");
        _ = w.next(); // move
        var amount = try std.fmt.parseInt(u8, w.next().?, 10);
        _ = w.next(); // from
        var src = try std.fmt.parseInt(u8, w.next().?, 10) - 1;
        _ = w.next(); // to
        var dst = try std.fmt.parseInt(u8, w.next().?, 10) - 1;

        var mv: []u8 = buf[0..amount];
        while (amount > 0) : (amount -= 1) {
            mv[amount - 1] = stacks[src].pop();
        }
        try stacks[dst].appendSlice(mv);
    }

    for (stacks) |*s| {
        std.debug.print("{c}", .{s.pop()});
    }
}
