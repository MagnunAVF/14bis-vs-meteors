airplane_14bis = {
    src = "images/14bis.png",
    width = 64,
    height = 64,
    x = 0,
    y = 0
}

function move_14bis()
    if love.keyboard.isDown('w') then
        airplane_14bis.y = airplane_14bis.y - 1
    end
    if love.keyboard.isDown('s') then
        airplane_14bis.y = airplane_14bis.y + 1
    end
    if love.keyboard.isDown('a') then
        airplane_14bis.x = airplane_14bis.x - 1
    end
    if love.keyboard.isDown('d') then
        airplane_14bis.x = airplane_14bis.x + 1
    end
end

-- Load some default values for our rectangle.
function love.load()
    love.window.setMode(320, 480, { resizable = false })
    love.window.setTitle("14Bis vs Meteors")

    background = love.graphics.newImage("images/background.png")
    airplane_14bis.image = love.graphics.newImage(airplane_14bis.src)
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    if love.keyboard.isDown('w', 'a', 's', 'd') then
        move_14bis()
    end
end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(background, 0, 0)

    love.graphics.draw(airplane_14bis.image, airplane_14bis.x, airplane_14bis.y)
end