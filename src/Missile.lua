
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
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gBlockSheet, gMissileQuad, self.x, self.y, 0,
        self.width / 4, self.height / 2)
end