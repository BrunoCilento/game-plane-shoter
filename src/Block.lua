Block = Class{}

function Block:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.inPlay = true
end

function Block:update(dt)
    --colocar efeito de particulas aqui
end

function Block:hit()
    self.inPlay = false
end

function Block:render()
    if self.inPlay then
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end
end