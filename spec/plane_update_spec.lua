_G.Class = require('lib.class')
require('src.Plane')

_G.VIRTUAL_WIDTH = 432
_G.PLANE_HEIGHT  = 6
_G.PLANE_WIDTH   = 20

describe('Plane:update(dt)', function()
  describe('normal movement (x <= VIRTUAL_WIDTH)', function()
    local p

    before_each(function()
      p = Plane(0, 40, PLANE_WIDTH, PLANE_HEIGHT, 100)
    end)

    it('advances x by dx * dt', function()
      p:update(1)
      assert.are.equal(100, p.x)
    end)

    it('scales x correctly with fractional dt', function()
      p:update(0.5)
      assert.are.equal(50, p.x)
    end)

    it('does not change y', function()
      p:update(1)
      assert.are.equal(40, p.y)
    end)

    it('does not change dx', function()
      p:update(1)
      assert.are.equal(100, p.dx)
    end)
  end)

  describe('wrap behavior (x > VIRTUAL_WIDTH)', function()
    local p

    before_each(function()
      p = Plane(VIRTUAL_WIDTH + 1, 40, PLANE_WIDTH, PLANE_HEIGHT, 100)
    end)

    it('drops y by PLANE_HEIGHT', function()
      p:update(1)
      assert.are.equal(46, p.y)
    end)

    it('resets x to re-enter from the left', function()
      p:update(1)
      assert.are.equal(0 - PLANE_WIDTH - 10, p.x)
    end)

    it('increases dx by 5', function()
      p:update(1)
      assert.are.equal(105, p.dx)
    end)
  end)
end)
