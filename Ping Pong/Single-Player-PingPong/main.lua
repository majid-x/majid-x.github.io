width = 1280
height = 720

vwidth = 432
vheight = 243
push = require 'push'
Class = require 'class'
require 'Ball'
require 'Paddle'
paddlespeed = 150
function love.load()
	--[[love.window.setMode(width,height,{
		fullscreen = false,
		resizable = false,
		vsync = true
	})]]
	love.window.setTitle('Pong')
	love.graphics.setDefaultFilter('nearest','nearest')
	math.randomseed(os.time())
	smallFont = love.graphics.newFont('04B_30__.TTF',8)
	score = love.graphics.newFont('04B_30__.TTF',32)
	--love.graphics.setFont(smallFont)
	sounds = {
		['paddle_hit'] = love.audio.newSource('paddle_hit.wav','static'),
		['score'] = love.audio.newSource('score.wav','static'),
		['wall_hit'] = love.audio.newSource('wall_hit.wav','static'),	
	}
	push:setupScreen(vwidth,vheight,width,height,{
		fullscreen = false,
		resizable = true,
		vsync = true
	})

	player1score = 0
	player2score = 0
	servingplayer = math.random(2) == 1 and 1 or 2
	turn = servingplayer
	paddle1 = Paddle(10,30,5,20)
	paddle2 = Paddle(vwidth-10,vheight-30,5,20)
	ball = Ball(vwidth/2-2,vheight/2-2,5,5)
	if servingplayer == 1 then
		ball.dx = 300
	else
		ball.dx = -300
	end
	gamestate = 'start'
end
function love.update(dt)
	if ball:collide(paddle1) then
		ball.dx = -ball.dx
		sounds['paddle_hit']:play()
		turn =1
	end
	if gamestate == 'serve' and turn == 1 then
		if ball.y > paddle2.y then
			paddle2.dy = paddlespeed
			paddle2:paddle2(dt,turn)

		else
			paddle2.dy = -paddlespeed
			paddle2:paddle2(dt,turn)
		end
	end
	if ball:collide(paddle2) then
		ball.dx = -ball.dx
		sounds['paddle_hit']:play()
		turn =2
		paddle2:paddle2(dt,turn)
	end
	if ball.y<= 0 then
		ball.dy = -ball.dy
		ball.y =0
		sounds['wall_hit']:play()
	end
	if ball.y>= vheight-4 then
		ball.dy = -ball.dy
		ball.y = vheight -4
		sounds['wall_hit']:play()
	end
	if	love.keyboard.isDown('up') then
		paddle1.dy = -paddlespeed
	elseif love.keyboard.isDown('down')then
		paddle1.dy = paddlespeed
	else
		paddle1.dy = 0
	end
	--[[if love.keyboard.isDown('up') then
		paddle2.dy = -paddlespeed
	elseif love.keyboard.isDown('down')then
		paddle2.dy = paddlespeed
	else
		paddle2.dy = 0
	end]]
	if gamestate == 'serve' then
		ball:update(dt)
		if ball.x<= 0 then
			player2score = player2score+1
			sounds['score']:play()
			servingplayer = 1
			turn = 1
			ball:reset()
			ball.dx = 300
			gamestate = 'start'
		end
		if ball.x >= vwidth-4 then
			player1score = player1score +1
			servingplayer = 2
			turn = 2
			sounds['score']:play()
			ball:reset()
			ball.dx = -300
			gamestate = 'start'
		end
		if player1score == 10 or player2score == 10 then
			gamestate = 'victory'
		end
	end

	paddle1:update(dt)
	end
function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'enter' or key == 'return' then
		if gamestate == 'start' then
			gamestate = 'play'
		elseif gamestate == 'play' then
			gamestate = 'serve'
		elseif gamestate == 'victory' then
			gamestate = 'start'
			player1score = 0
			player2score = 0
		end
	end
end
function love.draw()
	push:apply('start')
	love.graphics.clear(40/255,45/255,52/255,255/255)
	love.graphics.setFont(smallFont)
	if gamestate == 'start' then
		love.graphics.printf("Welcome to Pong!",0,20,vwidth,'center')
		love.graphics.printf("Press Enter to Play",0,32,vwidth,'center')
		love.graphics.setFont(score)
		love.graphics.print(player1score,vwidth/2-50,vheight/3)
		love.graphics.print(player2score,vwidth/2+30,vheight/3)
	elseif gamestate == 'play' then
		love.graphics.printf("Player " .. tostring(servingplayer) .. ("'s turn!"),0,20,vwidth,'center')
		love.graphics.printf("Press Enter to Serve",0,32,vwidth,'center')
		love.graphics.setFont(score)
		love.graphics.print(player1score,vwidth/2-50,vheight/3)
		love.graphics.print(player2score,vwidth/2+30,vheight/3)
	elseif gamestate == 'serve' then
		love.graphics.setFont(score)
		love.graphics.print(player1score,vwidth/2-50,vheight/3)
		love.graphics.print(player2score,vwidth/2+30,vheight/3)
	elseif gamestate == 'victory' and player1score == 10 then
		love.graphics.print("Player 1 won",vwidth/2-50,vheight/3)
	elseif gamestate == 'victory' and player2score == 10 then
		love.graphics.print("Player 2 won",vwidth/2-50,vheight/3)
	end
	
	paddle1:render()
	paddle2:render()
	ball:render()
	displayFPS()
	push:apply('end')
end

function displayFPS()
	love.graphics.setColor(0,1,0,1)
	love.graphics.setFont(smallFont)
	love.graphics.print('FPS ' .. tostring(love.timer.getFPS()),40,20)
	love.graphics.setColor(0,1,1,1)
end
