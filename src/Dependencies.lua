
push = require 'lib/push'


Class = require 'lib/class'

-- a few global constants, centralized
--require 'src/constants'

require 'src/Block'
require 'src/Bomb'
require 'src/Missile'
require 'src/Plane'
require 'src/Ground'
require 'src/LevelMaker'

require 'src/StateMachine'


-- each of the individual states our game can be in at once; each state has
-- its own update and render methods that can be called by our state machine
-- each frame, to avoid bulky code in main.lua
require 'src/states/BaseState'
require 'src/states/CountdownState'
require 'src/states/PlayState'
-- require 'src/states/ScoreState'
require 'src/states/TitleScreenState'
require 'src/states/HighScoreState'
require 'src/states/EnterHighScoreState'
require 'src/states/GameOverState'