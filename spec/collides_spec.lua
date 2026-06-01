-- Delegation tests: each entity must forward to AABB.collides().
-- Algorithm correctness lives in AABB_spec.lua.
_G.Class = require('lib.class')
require('src.Plane')
require('src.Missile')
require('src.Bomb')

local function box(x, y, w, h)
  return { x = x, y = y, width = w, height = h }
end

local function delegation_suite(label, make_entity)
  describe(label .. ':collides() delegates to AABB', function()
    local e

    before_each(function()
      e = make_entity(10, 10, 20, 20)
    end)

    it('returns true on overlap', function()
      assert.is_true(e:collides(box(15, 15, 20, 20)))
    end)

    it('returns false when apart', function()
      assert.is_false(e:collides(box(31, 10, 20, 20)))
    end)
  end)
end

delegation_suite('Plane',   function(x, y, w, h) return Plane(x, y, w, h, 0) end)
delegation_suite('Missile', function(x, y, w, h) return Missile(x, y, w, h, 0) end)
delegation_suite('Bomb',    function(x, y, w, h) return Bomb(x, y, w, h, 0) end)
