

PlayState = Class{__includes = BaseState}


-- plane
PLANE_WIDTH = 20
PLANE_HEIGHT = 6
PLANE_INITIAL_SPEED = 100 --100
-- missile
MISSILE_WIDTH = 5
MISSILE_HEIGHT = 2

-- bomb
BOMB_WIDTH = 2
BOMB_HEIGHT = 4


--building
BLOCK_WIDTH = 16
BLOCK_HEIGHT = 16
ROWS_NUMBER = 8 --max 8
COLUMNS_NUMBER = 8 --max 8
blocks_table = {}
ground_table = {}


function PlayState:enter(params)
    self.plane = Plane(-30, 40, PLANE_WIDTH, PLANE_HEIGHT, PLANE_INITIAL_SPEED)
    self.highScores = params.highScores
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.player_streak = params.player_streak
    self.missile_ammo = params.missile_ammo

    spawnBlocks()
    spawnGround()
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('p') then
            self.paused = false
            --gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('p') then
        self.paused = true
        --gSounds['pause']:play()
        return
    end


    self.plane:update(dt)

    if love.keyboard.wasPressed('m') and self.missile_ammo > 0 then
        if self.plane:shoot_missile(self.missile_ammo) then
            self.missile_ammo = self.missile_ammo - 1
        end
    end

    if love.keyboard.wasPressed('space') then
        self.plane:drop_bomb()
    end

    -- reset if we get to the ground
    if self.plane.y > GROUND_LEVEL - PLANE_HEIGHT then
        gStateMachine:change('game-over', {
            score = self.score,
            highScores = loadHighScores()
        })
    end

    -- game-over if plane hit a block
    for j = #blocks_table, 1, -1 do
        block = blocks_table[j]
        if self.plane:collides(block) then
            self.health = self.health - 1
            if self.health == 0 then
                gStateMachine:change('game-over', {
                score = self.score,
                highScores = loadHighScores()
            })
            end
        end
    end
    
    -- missile loop
    for i = #self.plane.missile_table, 1, -1 do
        missile = self.plane.missile_table[i]
        missile:update(dt)
        if missile.x > VIRTUAL_WIDTH then
            table.remove(self.plane.missile_table, i)
            self.player_streak = 0
            break
        end
        for j = #blocks_table, 1, -1 do
            block = blocks_table[j]
            if missile:collides(block) then
                table.remove(blocks_table, j)
                table.remove(self.plane.missile_table, i)
                self.score = self.score + 1 + math.floor(self.player_streak/5)
                self.player_streak = self.player_streak + 1
                break
            end
        end
    end

    -- bomb loop
    for i = #self.plane.bombs_table, 1, -1 do
        bomb = self.plane.bombs_table[i]
        bomb:update(dt)

        local hit_ground = false
        for _, ground in ipairs(ground_table) do
            if bomb:collides(ground) then
                hit_ground = true
                break
            end
        end
        if hit_ground or bomb.y > GROUND_LEVEL then
            table.remove(self.plane.bombs_table, i)
            self.player_streak = 0
        else
            for j = #blocks_table, 1, -1 do
                block = blocks_table[j]
                if bomb:collides(block) then
                    table.remove(blocks_table, j)
                    table.remove(self.plane.bombs_table, i)
                    self.score = self.score + 1 + math.floor(self.player_streak/5)
                    self.player_streak = self.player_streak + 1
                    break
                end
            end
        end
    end
end




function PlayState:render()
    local sx = VIRTUAL_WIDTH / gBackground:getWidth()
    local sy = VIRTUAL_HEIGHT / gBackground:getHeight()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gBackground, 0, 0, 0, sx, sy)

    --render score on the corner
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 40, 7, 38, 20)
    love.graphics.setFont(largeFont)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(self.score), VIRTUAL_WIDTH - 35, 10)

    self.plane:render()

    for i = #blocks_table, 1, -1 do
        block = blocks_table[i]
        block:render()
    end

    -- for i = #ground_table, 1, -1 do
    --     ground = ground_table[i]
    --     ground:render()
    -- end

    for i = #self.plane.missile_table, 1, -1 do
        missile = self.plane.missile_table[i]
        missile:render()
    end

    for i = #self.plane.bombs_table, 1, -1 do
        bomb = self.plane.bombs_table[i]
        bomb:render()
    end

    displayMissiles(self.missile_ammo)

end

function PlayState:exit()
end


function displayMissiles(missile_ammo)
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle('fill', 46, 7, 76, 13)
    love.graphics.setFont(smallFont)
    love.graphics.setColor(219/255, 124/255, 15/255, 1)
    love.graphics.print('Missiles: ', 50, 10)
    love.graphics.rectangle('line', 90, 10 + 2, 6, 4)
    love.graphics.rectangle('line', 100, 10 + 2, 6, 4)
    love.graphics.rectangle('line', 110, 10 + 2, 6, 4)
    for i = 1, missile_ammo, 1 do
        love.graphics.rectangle('fill', 90 + 10*(i-1), 10 + 2, 6, 4)
    end
end

function spawnBlocks()
    rows = ROWS_NUMBER
    cols = COLUMNS_NUMBER
    vertical_spacing = 0
    horizontal_spacing = 20

    for col = 1, cols do
        local quad = gBlockQuads[math.random(1, 4)]
        random_horizontal_spacing = math.random(0,5)
        x = 100 + (col - 1) * (BLOCK_WIDTH + horizontal_spacing) + random_horizontal_spacing
        for row = 1, rows do
            y = GROUND_LEVEL - 20 - BLOCK_HEIGHT - (row - 1) * (BLOCK_HEIGHT + vertical_spacing)
            table.insert(blocks_table, Block(x, y, BLOCK_WIDTH, BLOCK_HEIGHT, quad))
        end
    end
end

function spawnGround()
    table.insert(ground_table, Block(0, GROUND_LEVEL, VIRTUAL_WIDTH, VIRTUAL_HEIGHT - GROUND_LEVEL)) --ground
    table.insert(ground_table, Block(80, GROUND_LEVEL - 20, VIRTUAL_WIDTH - 90, 20)) --Base Block for the city
end