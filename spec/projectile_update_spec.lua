_G.Class = require('lib.class')
require('src.Missile')
require('src.Bomb')

describe('Missile:update(dt)', function()
  local m

  before_each(function()
    m = Missile(0, 0, 5, 2, 100)
  end)

  it('advances x by dx * dt', function()
    m:update(1)
    assert.are.equal(100, m.x)
  end)

  it('scales x correctly with fractional dt', function()
    m:update(0.5)
    assert.are.equal(50, m.x)
  end)

  it('accelerates dx by 1% each tick', function()
    m:update(1)
    assert.are.equal(100 * 1.01, m.dx)
  end)

  it('accelerates dx independently of dt', function()
    m:update(0.016)
    assert.are.equal(100 * 1.01, m.dx)
  end)

  it('does not change y', function()
    m:update(1)
    assert.are.equal(0, m.y)
  end)
end)

describe('Bomb:update(dt)', function()
  local b

  before_each(function()
    -- dy starts at 0 per Bomb:init
    b = Bomb(0, 0, 2, 4, 100)
  end)

  it('advances x by dx * dt', function()
    b:update(1)
    assert.are.equal(100, b.x)
  end)

  it('applies horizontal drag: dx decays by factor 0.989 each tick', function()
    b:update(1)
    assert.are.equal(100 * 0.989, b.dx)
  end)

  it('applies drag independently of dt', function()
    b:update(0.016)
    assert.are.equal(100 * 0.989, b.dx)
  end)

  it('y does not move on the first tick because dy starts at 0', function()
    b:update(1)
    assert.are.equal(0, b.y)
  end)

  it('increments dy by 1 each tick', function()
    b:update(1)
    assert.are.equal(1, b.dy)
  end)

  it('accumulates dy across ticks', function()
    b:update(1)
    b:update(1)
    assert.are.equal(2, b.dy)
  end)

  it('y falls by accumulated dy on the second tick', function()
    b:update(1)  -- dy goes 0→1, y moves by 0
    b:update(1)  -- dy goes 1→2, y moves by 1
    assert.are.equal(1, b.y)
  end)
end)
