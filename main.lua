function love.load()
    --love.window.setMode(0, 0, {fullscreen = true})
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    endGameBool = false
    pointsToScore = 7
    ----------------------------------
    starting_position_x = width/2
    starting_position_y = height/2  
    ------------------------------
    ball = {}
    ball.x = starting_position_x
    ball.y = starting_position_y
    ball.vx = 3
    ball.vy = 0
-------------------------
    paddle1 = {}
    paddle1.x = 0
    paddle1.y = 250
    paddle1.score = 0
--------------------------------
    paddle2 = {}
    paddle2.x = width - 10
    paddle2.y = 250
    paddle2.score = 0
-------------------------------
    shared = {}
    shared.speed = 2
    shared.pause = false
    shared.showRoundWonMessagePaddle1 = false
    shared.showRoundWonMessagePaddle2 = false
    shared.paddleHeight = 60
    shared.paddleWidth = 10
------------------------------
end

function love.update(dt) 
    

    
    if(not shared.pause) then
    checkInputsPaddle1() -- checks for w and s inputs for player 1
    
    checkInputsPaddle2() -- checks for arrow key inputs for player 2

    ballCeilingFloorCheck() -- checks if ball hits ceiling or floor
    
    basicBallMovement() -- moves ball


    --collision check paddle 1 
    collisionAction(collisionCheck(ball.x,ball.y, 10,10, paddle1.x,paddle1.y, 10,60),paddle1)


    --collision check paddle 2
    collisionAction(collisionCheck(ball.x,ball.y, 10,10, paddle2.x,paddle2.y, 10,60), paddle2)

    end
    
    --score updating
    pointScored()

    --handles end of game
    endGame(paddle1)
    endGame(paddle2)

end

function love.draw()
    if(not shared.pause) then
    love.graphics.rectangle("fill", ball.x, ball.y, 10 ,10)
    end
    
    love.graphics.rectangle("fill", paddle1.x, paddle1.y, shared.paddleWidth,shared.paddleHeight)
    
    love.graphics.rectangle("fill", paddle2.x, paddle2.y, 10,shared.paddleHeight)

    love.graphics.print(paddle1.score,30,30)

    love.graphics.print(paddle2.score,width -30, 30)

    if (not endGameBool) then
        if(showRoundWonMessagePaddle1) then 
            love.graphics.printf("Player 1 scored!,press p to continue",starting_position_x,starting_position_y + 10,150,"left")
        end

        if(showRoundWonMessagePaddle2) then
            love.graphics.printf("Player 2 scored!,press p to continue",starting_position_x,starting_position_y + 10,150,"left")
        end 
    end

    if(endGameBool) then
        if(paddle1.score == pointsToScore) then
        love.graphics.printf("Player 1 WON!!!!!!" ,starting_position_x,starting_position_y + 10,150,"left")

        elseif(paddle2.score == pointsToScore) then
            love.graphics.printf("Player 2 WON!!!!!!",starting_position_x,starting_position_y + 10,150,"left")
        end
    end
end

function checkInputsPaddle1() -- checks for paddle 1 input w and s, does not let it go off screen

    if love.keyboard.isDown("w") then
        if paddle1.y > 0 then
            paddle1.y = paddle1.y - shared.speed
        end
    end

    if love.keyboard.isDown("s") then
        if paddle1.y + 60 < height then
            paddle1.y = paddle1.y + shared.speed

        end
    end

end

function checkInputsPaddle2() -- check for paddle 2 input arrow key up and down, does not let it go off screen

    if love.keyboard.isDown("up") then
        if paddle2.y > 0 then
            paddle2.y = paddle2.y - shared.speed
        end
    end

    if love.keyboard.isDown("down") then
        if paddle2.y + 60 < height then
            paddle2.y = paddle2.y + shared.speed
        end
    end
end


function ballCeilingFloorCheck() -- checks if the ball is at the ceiling or the floor if it is bounce it up or down 
    if (ball.y <= 0) then
        ball.vy = -ball.vy
    end

    if (ball.y + 10 >= height) then
        ball.vy = -ball.vy
    end
end

function collisionCheck(ax, ay, awidth, aheight, bx, by, bwidth, bheight) --Axis Aligned Bounding Box (AABB) Collision take two boxes and if they overlap bounce it back
    return ax < bx + bwidth and
    ax + awidth > bx and
    ay < by + bheight and
    ay + aheight > by
end

function basicBallMovement() -- moves the ball in the direction of the velocity
    ball.x = ball.x + ball.vx
    ball.y = ball.y + ball.vy
end

function collisionAction(collisionCheck, paddle) -- takes a bool as if its true then switch ball direction on the x axis if it head or tail will implement later
    if (collisionCheck) then
        ball.vx = -ball.vx   

        if(ball.y >= paddle.y and ball.y <= paddle.y + (shared.paddleHeight / 3)) then -- top thid
            ball.vy = -1

        elseif (ball.y >= paddle.y + (2* shared.paddleHeight/3)) then --bottom third
            ball.vy = 1

        else
            ball.vy = 0
        end

    end
end

 
function pointScored() --updates points and resets the round
   if (ball.x < 0) then
      paddle2.score = paddle2.score + 1
      ball.x = starting_position_x
      ball.y = starting_position_y
      shared.pause = not shared.pause
      showRoundWonMessagePaddle2 = true
      ball.vy = 0

    elseif (ball.x > width) then
      paddle1.score = paddle1.score + 1
      ball.x = starting_position_x
      ball.y = starting_position_y
      shared.pause = not shared.pause
      showRoundWonMessagePaddle1 = true
      ball.vy = 0
   end
end



function love.keypressed(key) --when you press escape then it exits the game and when pressing p it pauses the game
    if (key == "escape") then
        love.event.quit()
    end
    if (key == "p") then
        shared.pause = not shared.pause
        showRoundWonMessagePaddle1 = false
        showRoundWonMessagePaddle2 = false
    end
end

function endGame(paddle) 
    if(paddle.score == 7) then
        shared.pause = true
        endGameBool = true 
    end
end


