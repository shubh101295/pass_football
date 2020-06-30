
push = require 'push'
Class = require 'class'

require "Player1"
require "Player2"
require "Ball"

local background = love.graphics.newImage('field.png')

WINDOW_HEIGTH = 720
WINDOW_WIDTH = 1280

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

function love.load()
	love.graphics.setDefaultFilter('nearest' , 'nearest')
	love.window.setTitle('Pass Football')

	background_image_width = background:getWidth()
	background_image_height = background:getHeight()
	
	smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)
	
	gamestate = 'pause'
	
	scoreTeam1 = 0 
	scoreTeam2 = 0
	team1 = {}
	team2 = {}
	ball = Ball()
	id1 = 1
	id2 = 1
	-- window_height = love.graphics.getHeight( )
	-- window_width = love.graphics.getWidth( )
	-- print(window_height , window_width)
	
	table.insert(team1 ,
				Player1(1,VIRTUAL_WIDTH/4 , VIRTUAL_HEIGHT/4-30) )
	table.insert(team1 ,
				Player1(2,VIRTUAL_WIDTH/4 , (3*VIRTUAL_HEIGHT)/4 -30) )
	table.insert(team2 ,
				Player2(1,(3*VIRTUAL_WIDTH)/4 , VIRTUAL_HEIGHT/4 - 30) )
	table.insert(team2 ,
				Player2(2,(3*VIRTUAL_WIDTH)/4 , (3*VIRTUAL_HEIGHT)/4 - 30) )
	
--	player11 = Player1(3,VIRTUAL_WIDTH/2 , VIRTUAL_HEIGHT/2-30)
--	player12 = Player1(2,VIRTUAL_WIDTH/4 , (3*VIRTUAL_HEIGHT)/4 -30)
--	player21 = Player2(1,(3*VIRTUAL_WIDTH)/4 , VIRTUAL_HEIGHT/4 - 30)
--	player22 = Player2(2,(3*VIRTUAL_WIDTH)/4 , (3*VIRTUAL_HEIGHT)/4 - 30)


	push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGTH,{
		vsync = true,
		fullscreen = false,
		resizable = true
	})

	love.keyboard.keysPressed = {}
end

function love.resize( w,h )
	push:resize(w,h)
	-- body
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
	if key == 'escape' then
		love.event.quit()
	end
	
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
	if love.keyboard.wasPressed('l') then
		id2 = (id2==1 and 2 or 1)
	end
	if love.keyboard.wasPressed('q') then
		id1 = (id1==1 and 2 or 1)
	end 

	-- window_height = love.graphics.getHeight( )
	-- window_width = love.graphics.getWidth( )
	-- print(window_height , window_width)
	
	if gamestate == "pause" then
		if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
			gamestate = "play"
		end
	else 	
		col1_val = team1[id1]:collides(team2[1])
		col1_val = col1_val * team1[id1]:collides(team2[2])
		col1_val = col1_val * team1[id1]:collides(team1[id1 == 1 and 2 or 1])
		col1_val = col1_val * team1[id1]:collides(ball)
		-- print(col1_val)
		team1[id1]:update(dt , col1_val)

		col2_val = team2[id2]:collides(team1[1])
		col2_val = col2_val * team2[id2]:collides(team1[2])
		col2_val = col2_val * team2[id2]:collides(team2[id2 == 1 and 2 or 1])
		col2_val = col2_val * team2[id2]:collides(ball)
		-- print(col2_val)
		team2[id2]:update(dt , col2_val)

		col_Ball_value = ball:collides(team1[1])
		col_Ball_value = col_Ball_value * ball:collides(team1[2])
		col_Ball_value = col_Ball_value * ball:collides(team2[1])
		col_Ball_value = col_Ball_value * ball:collides(team2[2])
		ball:update(dt , col_Ball_value)

		-- if col_Ball_value ~= 1 then
		-- 	print(col_Ball_value)
		-- end
		if ball.x == 25 then
			scoreTeam2 = scoreTeam2 + 1
			ball:reset()
			team1[1]:reset( VIRTUAL_WIDTH/4 , VIRTUAL_HEIGHT/4-30)
			team1[2]:reset( VIRTUAL_WIDTH/4 , (3*VIRTUAL_HEIGHT)/4 -30) 
			team2[1]:reset( (3*VIRTUAL_WIDTH)/4 , VIRTUAL_HEIGHT/4-30)
			team2[2]:reset( (3*VIRTUAL_WIDTH)/4 , (3*VIRTUAL_HEIGHT)/4 -30) 
			gamestate = "pause"
		elseif ball.x == VIRTUAL_WIDTH - 49 then
			scoreTeam1 = scoreTeam1 + 1
			ball:reset()
			team1[1]:reset( VIRTUAL_WIDTH/4 , VIRTUAL_HEIGHT/4-30)
			team1[2]:reset( VIRTUAL_WIDTH/4 , (3*VIRTUAL_HEIGHT)/4 -30) 
			team2[1]:reset( (3*VIRTUAL_WIDTH)/4 , VIRTUAL_HEIGHT/4-30)
			team2[2]:reset( (3*VIRTUAL_WIDTH)/4 , (3*VIRTUAL_HEIGHT)/4 -30) 
			gamestate = "pause"
		end
	end
	-- print(gamestate)
	--  print(scoreTeam1 , tostring(scoreTeam1)) 
	love.keyboard.keysPressed = {}
end

function love.draw()
	push:start()

	love.graphics.draw(background, 0 , 0,0 ,
		 VIRTUAL_WIDTH/background_image_width,
		 VIRTUAL_HEIGHT/(background_image_height-20))
	love.graphics.setFont(smallFont)
	love.graphics.print(tostring(gamestate),VIRTUAL_WIDTH/2-40 , 0)
		 
	love.graphics.setFont(mediumFont)
	love.graphics.print(tostring(scoreTeam1),VIRTUAL_WIDTH/2-40 , VIRTUAL_HEIGHT/3)
	love.graphics.print(tostring(scoreTeam2),VIRTUAL_WIDTH/2+25 , VIRTUAL_HEIGHT/3)
		 
	for k, pair in pairs(team1) do
        pair:render()
    end

    for k, pair in pairs(team2) do
        pair:render()
    end
    ball:render()

	push:finish()

end