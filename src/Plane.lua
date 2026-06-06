
local collides = require('src.AABB')

Plane = Class{}


function Plane:init(x, y, width, height, speed)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = 0
    self.missile_table = {}
    self.bombs_table = {}
    self.dx = speed
end


function Plane:reset()
    self.x = 0
    self.y = 40
    self.dx = 0
    self.bombs_table = {}
    self.missile_table = {}
end

function Plane:shoot_missile(missile_ammo)
    if #self.missile_table < missile_ammo then
        local missile = Missile(self.x + PLANE_WIDTH/4, self.y + self.height*3/5 + MISSILE_HEIGHT/2, MISSILE_WIDTH, MISSILE_HEIGHT, self.dx)
        table.insert(self.missile_table, missile)
        return true
    end
    return false
end

function Plane:drop_bomb()
    if #self.bombs_table < 2 then
        bomb = Bomb(self.x + PLANE_WIDTH/3, self.y + self.height*3/5, BOMB_WIDTH, BOMB_HEIGHT, self.dx)
        table.insert(self.bombs_table, bomb)
    end
end

function Plane:collides(block)
    return collides(self, block)
end

function Plane:update(dt)
    if self.x > VIRTUAL_WIDTH then
        self.y = self.y + PLANE_HEIGHT
        self.x = 0 - PLANE_WIDTH - 10
        self.dx = self.dx + 5
    else
        self.x = self.x + self.dx * dt
    end

end

function Plane:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gBlockSheet, gPlaneQuad, self.x, self.y, 0,
        self.width / 45, self.height / 16)
end