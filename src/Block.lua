Block = Class{}

function Block:init(x, y, width, height, quad)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.quad = quad

    self.inPlay = true
end

function Block:update(dt)
    --colocar efeito de particulas aqui
end

function Block:hit()
    self.inPlay = false
end

function Block:render()
    if not self.inPlay then return end
    if self.quad then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(gBlockSheet, self.quad, self.x, self.y, 0,
            self.width / 16, self.height / 16)
    else
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end
end