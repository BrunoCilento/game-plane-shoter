local collides = require('src.AABB')

-- Both rectangles are plain tables — collides() has no entity dependencies.
local function box(x, y, w, h)
  return { x = x, y = y, width = w, height = h }
end

-- Entity under test: 20×20 box at (10,10), spanning (10,10)→(30,30).
local A = box(10, 10, 20, 20)

describe('AABB.collides()', function()
  it('returns true on a clear overlap', function()
    assert.is_true(collides(A, box(15, 15, 20, 20)))
  end)

  it('returns true when one rectangle is fully inside the other', function()
    assert.is_true(collides(A, box(12, 12, 5, 5)))
  end)

  it('returns false when target is to the right', function()
    assert.is_false(collides(A, box(31, 10, 20, 20)))
  end)

  it('returns false when target is to the left', function()
    -- target right edge = -11 + 20 = 9, A left edge = 10
    assert.is_false(collides(A, box(-11, 10, 20, 20)))
  end)

  it('returns false when target is below', function()
    assert.is_false(collides(A, box(10, 31, 20, 20)))
  end)

  it('returns false when target is above', function()
    -- target bottom edge = -11 + 20 = 9, A top edge = 10
    assert.is_false(collides(A, box(10, -11, 20, 20)))
  end)

  it('returns false when right edges touch but do not overlap (strict >)', function()
    -- A right (30) == target left (30)
    assert.is_false(collides(A, box(30, 10, 20, 20)))
  end)

  it('returns false when bottom edges touch but do not overlap (strict >)', function()
    -- A bottom (30) == target top (30)
    assert.is_false(collides(A, box(10, 30, 20, 20)))
  end)
end)
