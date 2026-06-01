

HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update(dt)
    --return to title screen if we press escape
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('title', {
            highScores = self.highScores
        })
    end
end

function HighScoreState:render()
    love.graphics.setFont(largeFont)
    love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)

    --iterate over all 10 high scores
    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local score = self.highScores[i].score or '---'

        --score number (1-10)
        love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH/4, 60 + i*13, 50, 'left')

        --score name
        love.graphics.printf(name, VIRTUAL_WIDTH/4+38, 60 + i*13, 50, 'right')

        --score value
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH/2, 60 + i*13,100, 'right')
    end

    love.graphics.setFont(smallFont)
    love.graphics.printf("Press Esc to return to main menu", 0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end