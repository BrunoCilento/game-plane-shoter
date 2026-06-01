
local collides = require('src.AABB')

Bomb = Class{}

function Bomb:init(x, y, width, height, dx)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = dx
    self.dy = 0
end

function Bomb:collides(block)
    return collides(self, block)
end

function Bomb:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self.dx = self.dx * 0.989
    self.dy = self.dy + 1
end

function Bomb:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end