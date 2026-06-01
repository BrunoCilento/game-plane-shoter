

CountdownState = Class{__includes = BaseState}

COUNTDOWN_TIME = 0.75

function CountdownState:enter(params)
    self.highScores = params.highScores
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.player_streak = params.player_streak
    self.missile_ammo = params.missile_ammo
end


function CountdownState:init()
    self.count = 3
    self.timer = 0
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play', {
                highScores = self.highScores,
                health = self.health,
                score = self.score,
                player_streak = self.player_streak,
                level = self.level,
                missile_ammo = self.missile_ammo
            })
        end
    end
end

function CountdownState:render()
    -- render ground
    love.graphics.rectangle('fill', 0, GROUND_LEVEL, VIRTUAL_WIDTH, VIRTUAL_HEIGHT - GROUND_LEVEL)
    love.graphics.rectangle('fill', 80, GROUND_LEVEL - 20, VIRTUAL_WIDTH - 90, 20)
    
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end