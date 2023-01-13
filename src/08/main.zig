const std = @import("std");

const data = @embedFile("input.txt");

pub fn main() !void {
    var forest: [99][]const u8 = undefined;

    var iter = std.mem.tokenize(u8, data, "\n");
    var i: usize = 0;
    while (iter.next()) |next| {
        forest[i] = next;
        i += 1;
    }

    i = 1; // outer border trees are all visible so we do not need to check
    var p1: usize = 0;
    var p2: u32 = 0;
    while (i < forest.len - 1) : (i += 1) {
        var j: usize = 1;
        while (j < forest[i].len - 1) : (j += 1) {
            if (isVisible(&forest, j, i)) p1 += 1;
            const sc = score(&forest, j, i);
            if (sc > p2) p2 = sc;
        }
    }

    // add border: top and bottom rows fully +
    // 2 trees for all other columns
    p1 += 2 * (forest.len - 2) + 2 * (forest[0].len);

    std.debug.print("Visible trees: {d}\n", .{p1});
    std.debug.print("Best scenic score: {d}\n", .{p2});
}

fn isVisible(forest: [][]const u8, x: usize, y: usize) bool {
    var i: usize = 0;
    // check left
    while (i <= x) : (i += 1) {
        if (i == x) return true; // reached the tree and all trees in the path are smaller => is visible
        if (forest[y][i] >= forest[y][x]) break; // as soon as one tree is equal or taller that direction is not visible
    }
    // check right
    i = x + 1;
    while (i <= forest[y].len) : (i += 1) {
        if (i == forest[y].len) return true; // reached the tree and all trees in the path are smaller => is visible
        if (forest[y][i] >= forest[y][x]) break; // as soon as one tree is equal or taller that direction is not visible
    }
    // check up
    i = 0;
    while (i <= forest.len) : (i += 1) {
        if (i == y) return true; // reached the tree and all trees in the path are smaller => is visible
        if (forest[i][x] >= forest[y][x]) break; // as soon as one tree is equal or taller that direction is not visible
    }
    // check down
    i = y + 1;
    while (i <= forest.len) : (i += 1) {
        if (i == forest.len) return true; // reached the tree and all trees in the path are smaller => is visible
        if (forest[i][x] >= forest[y][x]) break; // as soon as one tree is equal or taller that direction is not visible
    }
    return false;
}

fn score(forest: [][]const u8, x: usize, y: usize) u32 {
    var i = x - 1;
    // check left
    var scoreLeft: u32 = 0;
    while (i >= 0) : (i -= 1) {
        scoreLeft += 1;
        if (forest[y][i] >= forest[y][x] or i == 0) break; // as soon as one tree is equal or taller score is ready
    }
    // check right
    i = x + 1;
    var scoreRight: u32 = 0;
    while (i < forest[y].len) : (i += 1) {
        scoreRight += 1;
        if (forest[y][i] >= forest[y][x]) break; // as soon as one tree is equal or taller score is ready
    }
    // check up
    i = y - 1;
    var scoreUp: u32 = 0;
    while (i >= 0) : (i -= 1) {
        scoreUp += 1;
        if (forest[i][x] >= forest[y][x] or i == 0) break; // as soon as one tree is equal or taller score is ready
    }
    // check down
    i = y + 1;
    var scoreDown: u32 = 0;
    while (i < forest.len) : (i += 1) {
        scoreDown += 1;
        if (forest[i][x] >= forest[y][x]) break; // as soon as one tree is equal or taller score is ready
    }
    return scoreLeft * scoreRight * scoreUp * scoreDown;
}
