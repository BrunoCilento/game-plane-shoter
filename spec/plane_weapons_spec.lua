_G.Class = require('lib.class')
require('src.Plane')
require('src.Missile')
require('src.Bomb')

_G.PLANE_WIDTH   = 20
_G.PLANE_HEIGHT  = 6
_G.MISSILE_WIDTH = 5
_G.MISSILE_HEIGHT = 2
_G.BOMB_WIDTH    = 2
_G.BOMB_HEIGHT   = 4

describe('Plane:shoot_missile(ammo)', function()
  local p

  before_each(function()
    p = Plane(10, 40, PLANE_WIDTH, PLANE_HEIGHT, 100)
  end)

  it('returns true and adds a missile when under the cap', function()
    local fired = p:shoot_missile(3)
    assert.is_true(fired)
    assert.are.equal(1, #p.missile_table)
  end)

  it('returns false and does not add a missile when at the cap', function()
    p:shoot_missile(1)
    local fired = p:shoot_missile(1)
    assert.is_false(fired)
    assert.are.equal(1, #p.missile_table)
  end)

  it('fills up to the cap then stops', function()
    p:shoot_missile(3)
    p:shoot_missile(3)
    p:shoot_missile(3)
    local fired = p:shoot_missile(3)
    assert.is_false(fired)
    assert.are.equal(3, #p.missile_table)
  end)

  it('spawned missile inherits the plane dx', function()
    p:shoot_missile(3)
    assert.are.equal(100, p.missile_table[1].dx)
  end)

  it('spawned missile x is plane.x + PLANE_WIDTH/2', function()
    p:shoot_missile(3)
    assert.are.equal(p.x + PLANE_WIDTH / 2, p.missile_table[1].x)
  end)

  it('spawned missile y is plane.y + height + MISSILE_HEIGHT/2', function()
    p:shoot_missile(3)
    assert.are.equal(p.y + p.height + MISSILE_HEIGHT / 2, p.missile_table[1].y)
  end)
end)

describe('Plane:drop_bomb()', function()
  local p

  before_each(function()
    p = Plane(10, 40, PLANE_WIDTH, PLANE_HEIGHT, 80)
  end)

  it('adds a bomb when none are in flight', function()
    p:drop_bomb()
    assert.are.equal(1, #p.bombs_table)
  end)

  it('allows a second bomb in flight', function()
    p:drop_bomb()
    p:drop_bomb()
    assert.are.equal(2, #p.bombs_table)
  end)

  it('does not add a third bomb when two are already in flight', function()
    p:drop_bomb()
    p:drop_bomb()
    p:drop_bomb()
    assert.are.equal(2, #p.bombs_table)
  end)

  it('spawned bomb inherits the plane dx', function()
    p:drop_bomb()
    assert.are.equal(80, p.bombs_table[1].dx)
  end)

  it('spawned bomb x is plane.x + PLANE_WIDTH/2', function()
    p:drop_bomb()
    assert.are.equal(p.x + PLANE_WIDTH / 2, p.bombs_table[1].x)
  end)

  it('spawned bomb y is plane.y + height', function()
    p:drop_bomb()
    assert.are.equal(p.y + p.height, p.bombs_table[1].y)
  end)
end)
