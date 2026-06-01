


TitleScreenState = Class{__includes = BaseState}

-- whether we're highlighting "Start", "High Scores" or config

local highlighted = 1

function TitleScreenState:enter(params)
    self.highScores = params.highScores
end

function TitleScreenState:update(dt)
    -- change the row to be highlighted
    if love.keyboard.wasPressed('up') then
        highlighted = math.max(1, highlighted-1)
    elseif love.keyboard.wasPressed('down') then
        highlighted = math.min(2, highlighted+1)
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if highlighted == 1 then
            gStateMachine:change('countdown', {
                highScores = self.highScores,
                health = 1,
                score = 0,
                player_streak = 0,
                missile_ammo = 1,
                level = 1
        })
        elseif highlighted == 2 then
            gStateMachine:change('high-scores', {
                highScores = self.highScores
        })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function TitleScreenState:render()
    --title
    love.graphics.setFont(largeFont)
    love.graphics.printf('Hello Plane!', 0, 20 , VIRTUAL_WIDTH, 'center')

    --if highlighted is 1, render this blue
    if highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')
    
    --reset the color
    love.graphics.setColor(1, 1, 1, 1)

    --if highlighted is 2, render this blue
    if highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, 'center')

    --reset the color
    love.graphics.setColor(1, 1, 1, 1)

end