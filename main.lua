function love.load()
	scale = 1;
	width, height = love.window.getDimensions();
	scale = love.window.getPixelScale();
	font = love.graphics.newFont("resources/digital-7.ttf", 24 * scale);
	love.graphics.setFont(font);
	newGame();
	-- other init here
end

function love.draw()
	for k, v in pairs(ents) do
		v:draw();
	end
end

function love.update(dt)
	-- update
	for k, v in pairs(ents) do
		v:update(dt);
	end
end

function love.keypressed(key)
	if (key == "escape") then
		love.event.quit();
	end
end

function love.keyreleased(key)

end

function love.mousepressed(x, y, btn)
	ents['player1']:input(y);
end

function love.mousereleased(x, y, btn)

end

function newGame()
	ents = {};
	ents['midway'] = require('entities.midway');
	ents['ball'] = require('entities.ball');
	ents['ball']:ctor();
	ents['scoreboard'] = require('entities.scoreboard');
	ents['scoreboard']:ctor();
	local pfactory = require('entities.paddle');
	ents['player1'] = pfactory:factory();
	ents['player1']:ctor();
	ents['player2'] = pfactory:factory();
	ents['player2']:ctor(2, false);
	
	-- consider passing the ball end to the scoreboard ctor so they're aware of each other
end