const std = @import("std");

const data = @embedFile("input.txt");

const range = struct {
    min: u16,
    max: u16,

    fn New(r: []const u8) !range {
        var rng = std.mem.split(u8, r, "-");
        var min = try std.fmt.parseInt(u16, rng.next() orelse unreachable, 10);
        var max = try std.fmt.parseInt(u16, rng.next() orelse unreachable, 10);
        return .{
            .min = min,
            .max = max,
        };
    }
};

pub fn main() !void {
    // Split data per line and comma
    var iter = std.mem.split(u8, data, "\n");

    var res: u32 = 0;
    while (iter.next()) |next| {
        // split on the comma
        var pairs = std.mem.split(u8, next, ",");

        // create ranges
        var a = try range.New(pairs.next() orelse break);
        var b = try range.New(pairs.next() orelse break);

        if (redundant(a, b)) {
            res += 1;
        }
    }

    std.debug.print("Redundant pairs: {d}\n", .{res});
}

fn redundant(a: range, b: range) bool {
    return (a.min <= b.min and a.max >= b.min) or (b.min <= a.min and b.max >= a.min);
}
