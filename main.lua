SCREEN_WIDTH = 320
SCREEN_HEIGHT = 480
MAX_METEORS = 12
METEORS_TO_WIN = 10
DESTROYED_METEORS = 0

airplane_14bis = {
    src = "images/14bis.png",
    width = 55,
    height = 63,
    x = SCREEN_WIDTH/2 - 64/2,
    y = SCREEN_HEIGHT - 64/2,
    shoots = {}
}

function shoot_action()
    shoot_audio:play()
    local shoot = {
        x = airplane_14bis.x + airplane_14bis.width/2,
        y = airplane_14bis.y,
        width = 16,
        height = 16
    }

    table.insert(airplane_14bis.shoots, shoot)
end

function move_shoots()
    for i = #airplane_14bis.shoots, 1, -1 do
        if airplane_14bis.shoots[i].y > 0 then
            airplane_14bis.shoots[i].y = airplane_14bis.shoots[i].y - 1
        else
            table.remove(airplane_14bis.shoots[i])
        end
    end
end

function destroy_airplane()
    destruction_audio:play()
    airplane_14bis.src = "images/explosion.png"
    airplane_14bis.image = love.graphics.newImage(airplane_14bis.src)
    airplane_14bis.width = 67
    airplane_14bis.height = 77
end

function has_collision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x2 < x1 + w1 and
        x1 < x2 + w2 and
        y1 < y2 + h2 and
        y2 < y1 + h1
end

meteors = {}

function create_meteor()
    meteor = {
        x = math.random(SCREEN_WIDTH),
        y = -70,
        width = 50,
        height = 44,
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

function change_background_music()
    environment_audio:stop()
    game_over_audio:play()
end

function check_collision_with_airplane()
    for _, meteor in pairs(meteors) do
        if has_collision(meteor.x, meteor.y, meteor.width, meteor.height,
            airplane_14bis.x, airplane_14bis.y, airplane_14bis.width, airplane_14bis.height) then
            change_background_music()
            destroy_airplane()
            GAME_OVER = true
        end
    end
end

function check_collision_with_shoots()
    for i = #airplane_14bis.shoots, 1, -1 do
        for j = #meteors, 1, -1 do
            if has_collision(airplane_14bis.shoots[i].x, airplane_14bis.shoots[i].y, airplane_14bis.shoots[i].width, airplane_14bis.shoots[i].height,
                meteors[j].x, meteors[j].y, meteors[j].width, meteors[j].height) then
                DESTROYED_METEORS = DESTROYED_METEORS + 1
                table.remove(airplane_14bis.shoots, i)
                table.remove(meteors, j)
                break
            end
        end
    end
end

function check_collisions()
    check_collision_with_airplane()
    check_collision_with_shoots()
end

function check_game_win()
    if DESTROYED_METEORS >= METEORS_TO_WIN then
        environment_audio:stop()
        WINNER = true
        winner_audio:play()
    end
end

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, { resizable = false })
    love.window.setTitle("14Bis vs Meteors")

    math.randomseed(os.time())

    background = love.graphics.newImage("images/background.png")
    game_over_img = love.graphics.newImage("images/gameover.png")
    winner_img = love.graphics.newImage("images/winner.png")

    airplane_14bis.image = love.graphics.newImage(airplane_14bis.src)
    meteor_img = love.graphics.newImage("images/meteor.png")
    shoot_img = love.graphics.newImage("images/shoot.png")

    shoot_audio = love.audio.newSource("audios/shoot.wav", "static")
    destruction_audio = love.audio.newSource("audios/destruction.wav", "static")

    game_over_audio = love.audio.newSource("audios/game_over.wav", "static")
    winner_audio = love.audio.newSource("audios/winner.wav", "static")

    environment_audio = love.audio.newSource("audios/environment.wav", "static")
    environment_audio:setLooping(true)
    environment_audio:play()
end

function love.update(dt)
    if not GAME_OVER and not WINNER then
        if love.keyboard.isDown('w', 'a', 's', 'd') then
            move_14bis()
        end

        remove_meteors()

        if #meteors < MAX_METEORS then
            create_meteor()
        end

        move_meteors()
        move_shoots()
        check_collisions()
        check_game_win()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        shoot_action()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(airplane_14bis.image, airplane_14bis.x, airplane_14bis.y)

    love.graphics.print("Meteors to win: "..(METEORS_TO_WIN - DESTROYED_METEORS), 0, 0)

    for _, meteor in pairs(meteors) do
        love.graphics.draw(meteor_img, meteor.x, meteor.y)
    end

    for _, shoot in pairs(airplane_14bis.shoots) do
        love.graphics.draw(shoot_img, shoot.x, shoot.y)
    end

    if GAME_OVER then
        love.graphics.draw(game_over_img, SCREEN_WIDTH/2 - game_over_img:getWidth()/2, SCREEN_HEIGHT/2 - game_over_img:getHeight()/2)
    end

    if WINNER then
        love.graphics.draw(winner_img, SCREEN_WIDTH/2 - winner_img:getWidth()/2, SCREEN_HEIGHT/2 - winner_img:getHeight()/2)
    end
end