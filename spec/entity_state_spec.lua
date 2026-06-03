_G.Class = require('lib.class')
require('src.Plane')
require('src.Block')

describe('Plane:reset()', function()
  local p

  before_each(function()
    p = Plane(99, 55, 20, 6, 200)
    -- populate weapon tables so reset actually clears them
    table.insert(p.missile_table, {})
    table.insert(p.bombs_table, {})
  end)

  it('sets x to 0', function()
    p:reset()
    assert.are.equal(0, p.x)
  end)

  it('sets y to 40', function()
    p:reset()
    assert.are.equal(40, p.y)
  end)

  it('sets dx to 0', function()
    p:reset()
    assert.are.equal(0, p.dx)
  end)

  it('clears missile_table', function()
    p:reset()
    assert.are.equal(0, #p.missile_table)
  end)

  it('clears bombs_table', function()
    p:reset()
    assert.are.equal(0, #p.bombs_table)
  end)
end)

describe('Block:hit()', function()
  local b

  before_each(function()
    b = Block(0, 0, 14, 15)
  end)

  it('inPlay is true on a fresh block', function()
    assert.is_true(b.inPlay)
  end)

  it('sets inPlay to false', function()
    b:hit()
    assert.is_false(b.inPlay)
  end)

  it('is idempotent when called twice', function()
    b:hit()
    b:hit()
    assert.is_false(b.inPlay)
  end)
end)
