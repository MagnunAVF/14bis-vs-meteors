SCREEN_WIDTH = 320
SCREEN_HEIGHT = 480
MAX_METEORS = 12

airplane_14bis = {
    src = "images/14bis.png",
    width = 64,
    height = 64,
    x = SCREEN_WIDTH/2 - 64/2,
    y = SCREEN_HEIGHT - 64/2
}

meteors = {}

function create_meteor()
    meteor = {
        x = math.random(SCREEN_WIDTH),
        y = -70,
        weight = math.random(3),
        horizontal_movement = math.random(-1,1)
    }
    table.insert( meteors, meteor)
end

function move_meteors()
    for _, meteor in pairs(meteors) do
        meteor.y = meteor.y + meteor.weight
        meteor.x = meteor.x + meteor.horizontal_movement
    end
end

function remove_meteors()
    for i = #meteors, 1, -1 do
        if meteors[i].y > SCREEN_HEIGHT then
            table.remove(meteors, i)
        end
    end
end

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

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, { resizable = false })
    love.window.setTitle("14Bis vs Meteors")

    math.randomseed(os.time())

    background = love.graphics.newImage("images/background.png")
    airplane_14bis.image = love.graphics.newImage(airplane_14bis.src)
    meteor_img = love.graphics.newImage("images/meteor.png")
end

function love.update(dt)
    if love.keyboard.isDown('w', 'a', 's', 'd') then
        move_14bis()
    end

    remove_meteors()
    if #meteors < MAX_METEORS then
        create_meteor()
    end
    move_meteors()
end

function love.draw()
    love.graphics.draw(background, 0, 0)

    love.graphics.draw(airplane_14bis.image, airplane_14bis.x, airplane_14bis.y)

    for _, meteor in pairs(meteors) do
        love.graphics.draw(meteor_img, meteor.x, meteor.y)
    end
end