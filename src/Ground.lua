Ground = Class{}

function Ground:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    -- self.blocks_table = {}
    -- table.insert(self.blocks_table, block)
end

function Ground:update(dt)
end

function Ground:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end