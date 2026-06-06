-- Tests the bomb-vs-ground-table collision logic added to PlayState.
-- A bomb should stop at the city base (x >= 80, y = 200, h = 20),
-- but must pass through the open area to the left of it.
_G.Class = require('lib.class')
require('src.Bomb')

local BOMB_W = 2
local BOMB_H = 4

local GROUND_LEVEL   = 220
local CITY_BASE_X    = 80
local CITY_BASE_Y    = GROUND_LEVEL - 20  -- 200
local CITY_BASE_W    = 432 - 90
local CITY_BASE_H    = 20

local function city_base()
  return { x = CITY_BASE_X, y = CITY_BASE_Y, width = CITY_BASE_W, height = CITY_BASE_H }
end

local function flat_ground()
  return { x = 0, y = GROUND_LEVEL, width = 432, height = 23 }
end

describe('Bomb collision with city-base block', function()
  it('collides when bomb overlaps the top of the city base', function()
    local bomb = Bomb(100, CITY_BASE_Y, BOMB_W, BOMB_H, 0)
    assert.is_true(bomb:collides(city_base()))
  end)

  it('does not collide when bomb is fully above the city base', function()
    local bomb = Bomb(100, CITY_BASE_Y - BOMB_H, BOMB_W, BOMB_H, 0)
    assert.is_false(bomb:collides(city_base()))
  end)

  it('does not collide when bomb x is left of the city base', function()
    -- x=10 is before the base starts at x=80; same y-level should not hit
    local bomb = Bomb(10, CITY_BASE_Y, BOMB_W, BOMB_H, 0)
    assert.is_false(bomb:collides(city_base()))
  end)
end)

describe('Bomb collision with flat ground', function()
  it('collides when bomb reaches ground level', function()
    local bomb = Bomb(10, GROUND_LEVEL, BOMB_W, BOMB_H, 0)
    assert.is_true(bomb:collides(flat_ground()))
  end)

  it('does not collide when bomb is above the ground', function()
    local bomb = Bomb(10, GROUND_LEVEL - BOMB_H, BOMB_W, BOMB_H, 0)
    assert.is_false(bomb:collides(flat_ground()))
  end)
end)
