-- Load some default values for our rectangle.
function love.load()
    love.window.setMode(320, 480, { resizable = false })
    love.window.setTitle("14Bis vs Meteors")

    background = love.graphics.newImage("images/background.png")

    x, y, w, h = 20, 20, 60, 20
end

-- Increase the size of the rectangle every frame.
function love.update(dt)

end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(background, 0, 0)

    love.graphics.rectangle("fill", x, y, w, h)
end