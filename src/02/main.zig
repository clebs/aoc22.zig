const std = @import("std");

const data = @embedFile("input.txt");

// Example on the puzzle description
// const data =
//     \\A Y
//     \\B X
//     \\C Z
// ;

const move = enum(u8) {
    Rock = 1,
    Paper = 2,
    Scissor = 3,

    // return the move self wins against
    fn winsAgainst(self: move) move {
        switch (self) {
            .Rock => return .Scissor,
            .Paper => return .Rock,
            .Scissor => return .Paper,
        }
    }

    // return the move self looses against
    fn loosesAgainst(self: move) move {
        switch (self) {
            .Rock => return .Paper,
            .Paper => return .Scissor,
            .Scissor => return .Rock,
        }
    }
};

pub fn main() !void {
    var iter = std.mem.split(u8, data, "\n");
    var score: u32 = 0;

    // part 1
    while (iter.next()) |round| {
        const opponent = toMove(round[0]);
        const me = toMove(round[2]);

        // draw is 3 points + drawn move
        if (me == opponent) {
            score += 3 + @enumToInt(me);
        } else if (me.winsAgainst() == opponent) {
            score += 6 + @enumToInt(me);
        } else {
            score += @enumToInt(me);
        }
    }
    std.debug.print("Score part 1: {d}\n", .{score});

    // part 2
    score = 0;
    iter.reset();
    while (iter.next()) |round| {
        const opponent = toMove(round[0]);

        switch (round[2]) {
            // I loose
            'X' => score += @enumToInt(opponent.winsAgainst()),
            // draw
            'Y' => score += 3 + @enumToInt(opponent),
            // I win
            'Z' => score += 6 + @enumToInt(opponent.loosesAgainst()),
            else => unreachable,
        }
    }

    std.debug.print("Score part 2: {d}\n", .{score});
}

fn toMove(letter: u8) move {
    switch (letter) {
        'A', 'X' => return move.Rock,
        'B', 'Y' => return move.Paper,
        'C', 'Z' => return move.Scissor,
        else => unreachable,
    }
}
