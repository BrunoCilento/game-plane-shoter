
local collides = require('src.AABB')

Missile = Class{}

function Missile:init(x, y, width, height, dx)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = dx
    self.dy = 0
end

function Missile:collides(block)
    return collides(self, block)
end

function Missile:update(dt)
    self.x = self.x + self.dx * dt
    self.dx = self.dx * 1.01
end

function Missile:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end