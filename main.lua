function love.load()
	scale = 1;
	width, height = love.window.getDimensions();
	scale = love.window.getPixelScale(); -- used to scale to device - helps with high res mobile
	font = love.graphics.newFont("resources/digital-7.ttf", 24 * scale); -- multiplying the size by scale makes it look consistent cross resolution
	love.graphics.setFont(font);
	newGame();
	-- other init here
end

function love.draw()
	-- draw all entities in the game
	for k, v in pairs(ents) do
		v:draw();
	end
end

function love.update(dt)
	-- update all entities in the game
	for k, v in pairs(ents) do
		v:update(dt);
	end
end

function love.keypressed(key)
	-- need to be able to leave the game, after all
	if (key == "escape") then
		love.event.quit();
	end
end

function love.keyreleased(key)
	-- originally i was going to use a click and drag movement system
	-- while maintaining keyboard compatibility, but it didnt seem worth the effort
	-- plus i didnt want my thumb all over the screen constantly on mobile
end

function love.mousepressed(x, y, btn)
	-- this covers both physical mouse and touchscreen input
	-- input is only routed to player1 as player2 is ai controlled
	ents['player1']:input(y);
end

function love.mousereleased(x, y, btn)
	-- left here as a shell for future games
end

function newGame()
	-- laziest way to initialise a game
	-- the game never actually resets, the ball just tells the scoreboard to score
	-- then moves back to midfield and "serves" itself
	ents = {};
	ents['midway'] = require('entities.midway');
	ents['scoreboard'] = require('entities.scoreboard');
	ents['scoreboard']:ctor();
	ents['ball'] = require('entities.ball');
	ents['ball']:ctor(ents['scoreboard']);
	local pfactory = require('entities.paddle');
	ents['player1'] = pfactory:factory();
	ents['player1']:ctor();
	ents['player2'] = pfactory:factory();
	ents['player2']:ctor(2, true);
end