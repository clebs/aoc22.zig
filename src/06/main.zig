const std = @import("std");

const data = @embedFile("input.txt");

const PACKET_SIZE: u8 = 14; // change to 4 for part 1

pub fn main() !void {
    var i: usize = 0;

    outer: while (i < data.len - PACKET_SIZE) : (i += 1) {
        const packet = data[i .. i + PACKET_SIZE];

        for (packet) |c, idx| {
            if (std.mem.indexOfScalar(u8, packet[idx + 1 ..], c) != null) {
                continue :outer;
            }
        }
        break;
    }
    std.debug.print("Marker at: {d}\n", .{i + PACKET_SIZE});
}
