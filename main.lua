function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    ----------------------------------
    starting_position_x = width/2
    starting_position_y = height/2  
    ------------------------------
    ball = {}
    ball.x = starting_position_x
    ball.y = starting_position_y
    ball.vx = 1
    ball.vy = 0
-------------------------
    paddle1 = {}
    paddle1.x = 0
    paddle1.y = 250
    paddle1.score = 0
--------------------------------
    paddle2 = {}
    paddle2.x = 790
    paddle2.y = 250
    paddle2.score = 0
-------------------------------
    shared = {}
    shared.speed = 2
    shared.pause = false
    shared.showRoundWonMessagePaddle1 = false
    shared.showRoundWonMessagePaddle2 = false

------------------------------
end

function love.update(dt) 
    

    
    if(not shared.pause) then
    checkInputsPaddle1() -- checks for w and s inputs for player 1
    
    checkInputsPaddle2() -- checks for arrow key inputs for player 2

    ballCeilingFloorCheck() -- checks if ball hits ceiling or floor
    
    basicBallMovement() -- moves ball


    --collision check paddle 1 
    collisionAction(collisionCheck(ball.x,ball.y, 10,10, paddle1.x,paddle1.y, 10,60))


    --collision check paddle 2
    collisionAction(collisionCheck(ball.x,ball.y, 10,10, paddle2.x,paddle2.y, 10,60))

    --score updating
    pointScored()
    end

    --pauses game if you press escape or the space bar
    gamePaused()
  

end

function love.draw()
    love.graphics.rectangle("fill", ball.x, ball.y, 10 ,10)
    
    love.graphics.rectangle("fill", paddle1.x, paddle1.y, 10,60)
    
    love.graphics.rectangle("fill", paddle2.x, paddle2.y, 10,60)

    love.graphics.print(paddle1.score,30,30,0,1,1,10,10)

    love.graphics.print(paddle2.score,30,30,0,1,1,-745,10)

    if(showRoundWonMessagePaddle1) then 
        love.graphics.printf("Player 1 scored!,press p to continue",starting_position_x,starting_position_y + 10,100,"left")
    end

    if(showRoundWonMessagePaddle2) then
        love.graphics.printf("Player 2 scored!,press p to continue",starting_position_x,starting_position_y + 10,100,"left")
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

function collisionAction(collisionCheck) -- takes a bool as if its true then switch ball direction on the x axis if it head or tail will implement later
    if (collisionCheck) then
        ball.vx = -ball.vx   
    end
end




function colTest(col) -- testing still
    if (collisionCheck) then
        ball.vx = -ball.vx   
    end

    if (ball.vy == 1 or ball.vy == -1) then

    end


end

function pointScored() 
   if (ball.x == 0) then
      paddle2.score = paddle2.score + 1
      ball.x = starting_position_x
      ball.y = starting_position_y
      shared.pause = not shared.pause
      showRoundWonMessagePaddle2 = true

    elseif (ball.x == width) then
      paddle1.score = paddle1.score + 1
      ball.x = starting_position_x
      ball.y = starting_position_y
      shared.pause = not shared.pause
      showRoundWonMessagePaddle1 = true
   end
end

function gamePaused() -- can pause and unpause the game using spacebar and escape
    if(love.keyboard.isDown("p")) then
        shared.pause = not shared.pause
        showRoundWonMessagePaddle1 = false
        showRoundWonMessagePaddle2 = false
    end
end
