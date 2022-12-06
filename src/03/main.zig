const std = @import("std");
const Allocator = std.mem.Allocator;

const data = @embedFile("input.txt");

const lowercaseOffset = 96;
const uppercaseOffset = 38;

const backpack = struct {
    items: []const u8,

    fn new(items: []const u8) backpack {
        return .{ .items = items };
    }

    fn repeatedItem(self: backpack) u8 {
        const comps = self.compartments();
        for (comps.a) |a| {
            for (comps.b) |b| {
                if (a == b) return a;
            }
        }
        return 0;
    }

    fn compartments(self: backpack) struct { a: []const u8, b: []const u8 } {
        if (self.items.len == 0) return .{ .a = "", .b = "" };

        return .{ .a = self.items[0 .. self.items.len / 2], .b = self.items[self.items.len / 2 ..] };
    }

    fn toMutable(self: backpack, alloc: Allocator) ![]u8 {
        var mut = try alloc.alloc(u8, self.items.len);
        std.mem.copy(u8, mut, self.items);

        return mut;
    }

    fn badge(bps: [3]backpack, alloc: Allocator) !u8 {
        // Sorting and binary search is better than iterating all 3 arrays which is O(nˆ2)
        // Sorts are O(n*log(n)) worst case
        const a = try bps[0].toMutable(alloc);
        defer alloc.free(a);
        const b = try bps[1].toMutable(alloc);
        defer alloc.free(b);

        std.sort.sort(u8, a, {}, std.sort.asc(u8));
        std.sort.sort(u8, b, {}, std.sort.asc(u8));

        // binary search is also O(n*log(n)) worst case
        for (bps[2].items) |c| {
            // if c is not found in a or b, continue the loop
            _ = std.sort.binarySearch(u8, c, a, {}, order_u8) orelse continue;
            _ = std.sort.binarySearch(u8, c, b, {}, order_u8) orelse continue;

            // no continue reached => found in both
            return c;
        }
        unreachable;
    }

    fn order_u8(context: void, lhs: u8, rhs: u8) std.math.Order {
        _ = context;
        return std.math.order(lhs, rhs);
    }
};

pub fn main() !void {
    var iter = std.mem.split(u8, data, "\n");
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit()) std.log.err("Memory leak detected", .{});
    const alloc = gpa.allocator();

    // // part 1
    // var total: u32 = 0;
    // while (iter.next()) |items| {
    //     const bp = backpack.new(items);
    //     const r = bp.repeatedItem();
    //     const score = if (r > lowercaseOffset) r - lowercaseOffset else r - uppercaseOffset;
    //     std.debug.print("Backpack {s} has repeated char: {c} with value {d}\n", .{ bp.items, r, score });
    //     total += score;
    // }

    // std.debug.print("\nTotal score: {d}\n", .{total});

    // part 2
    var total: u32 = 0;
    while (iter.next()) |a| {
        const b = iter.next() orelse break;
        const c = iter.next() orelse break;

        const bpa = backpack.new(a);
        const bpb = backpack.new(b);
        const bpc = backpack.new(c);

        const badge = try backpack.badge(.{ bpa, bpb, bpc }, alloc);
        total += if (badge > lowercaseOffset) badge - lowercaseOffset else badge - uppercaseOffset;
    }

    std.debug.print("Total badges score: {d}\n", .{total});
}
