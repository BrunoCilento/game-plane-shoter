-- Returns true if two axis-aligned rectangles overlap (strict inequality —
-- shared edges do not count as a hit).
-- Both arguments must expose x, y, width, height fields.
-- Usage: local collides = require('src.AABB'); collides(plane, block)
local function collides(a, b)
  return a.x < b.x + b.width
     and a.x + a.width > b.x
     and a.y < b.y + b.height
     and a.y + a.height > b.y
end

return collides
