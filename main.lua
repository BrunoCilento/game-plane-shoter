-- personal remake of the plane shoter


-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
-- https://github.com/Ulydev/push

require 'src/Dependencies'


-- screen size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
-- virtual size
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

GROUND_LEVEL = 220




-- initial function to start the game
function love.load()
    -- nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text and graphics
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("Tower Destroyer")
    -- set RNG
    math.randomseed(os.time())

    microFont = love.graphics.newFont('fonts/font.ttf', 4)
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/font.ttf', 14)
    largeFont = love.graphics.newFont('fonts/font.ttf', 20)
    hugeFont = love.graphics.newFont('fonts/font.ttf', 40)
    love.graphics.setFont(smallFont)


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
        })



    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end, -- first screen, can go to score / config / choose plane
        ['countdown'] = function() return CountdownState() end, --countdown to start the game
        ['play'] = function() return PlayState() end, --play the game
        ['game-over'] = function() return GameOverState() end, --show when player lose
        ['high-scores'] = function() return HighScoreState() end, --high-score screen
        ['enter-high-score'] = function() return EnterHighScoreState() end, --enter high-score
        ['victory'] = function() return VictoryState() end --show when player win the level

    }
    gStateMachine:change('title', {
        highScores = loadHighScores()
    })

    -- initialize input table
    love.keyboard.keysPressed = {}

end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

-- function to draw on screen
function love.draw()
    -- begin rendering at virtual resolution
    push:start()

    -- set a screen color
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)



    gStateMachine:render()

    displayFPS()

    push:finish()
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10) 
end

function loadHighScores()
    love.filesystem.setIdentity('towerdestroyer')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('towerdestroyer.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'CTO\n'
            scores = scores .. tostring(i * 10) .. '\n'
        end

        love.filesystem.write('towerdestroyer.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('towerdestroyer.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores
end