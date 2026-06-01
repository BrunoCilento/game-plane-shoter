--[[
    Creates randomized levels for our Breakout game. Returns a table of
    bricks that the game can render, based on the current level we're at
    in the game.
]]

LevelMaker = Class{}

--[[
    Creates a table of Bricks to be returned to the main game, with different
    possible ways of randomizing rows and columns of bricks. Calculates the
    brick colors and tiers to choose based on the level passed in.
]]

ROWS_NUMBER = 4 --max 8
COLUMNS_NUMBER = 1 --max 8
VERTICAL_SPACING = 1
HORIZONTAL_SPACING = 20

function LevelMaker.createMap(level)
    local blocks_table = {}

    rows = ROWS_NUMBER
    cols = COLUMNS_NUMBER


    for col = 1, cols do
        if col == 1 then
            x = 100 + math.random(0,20)
        else
            x = x_before + BLOCK_WIDTH + math.random(0,5)
        end
        x_before = x
        for row = 1, rows do
            y = GROUND_LEVEL - BLOCK_HEIGHT - (row - 1) * (BLOCK_HEIGHT + VERTICAL_SPACING) -- Offset from the top
            b = Block(x, y, BLOCK_WIDTH, BLOCK_HEIGHT)
            table.insert(blocks_table, b)
        end
    end
    if #blocks_table == 0 then
        return self.createMap(level)
    else
        return blocks_table
    end
end