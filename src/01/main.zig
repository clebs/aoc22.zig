const std = @import("std");

const data = @embedFile("input.txt");

pub fn main() !void {
    // Part 1
    const h = try highestCalories(data);
    std.debug.print("Highest calories on one elf: {d}\n", .{h});

    // part 2
    const h3 = try highest3(data);
    std.debug.print("Highest calories on 3 elfs: {d}\n", .{h3});
}

fn highestCalories(d: []const u8) !u32 {
    var iter = std.mem.split(u8, d, "\n");

    var res: u32 = 0;
    var current: u32 = 0;
    while (iter.next()) |next| {
        if (next.len == 0) {
            if (current > res) {
                res = current;
            }
            current = 0;
        } else {
            current += try std.fmt.parseInt(u32, next, 0);
        }
    }
    return res;
}

fn highest3(d: []const u8) !u32 {
    var iter = std.mem.split(u8, d, "\n");

    var res = [_]u32{0} ** 3;
    var current: u32 = 0;
    while (iter.next()) |next| {
        if (next.len == 0) {
            const i = minIndex(&res);
            if (current > res[i]) {
                res[i] = current;
            }
            current = 0;
        } else {
            current += try std.fmt.parseInt(u32, next, 0);
        }
    }

    return res[0] + res[1] + res[2];
}

fn minIndex(a: []u32) usize {
    var res: usize = 0;
    for (a) |_, i| {
        if (a[i] < a[res]) {
            res = i;
        }
    }
    return res;
}
