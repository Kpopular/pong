-- the scoreboard
local scoreboard = {};

function scoreboard:ctor()
	-- players should start without points of course
	self.p1 = 0;
	self.p2 = 0;
end

function scoreboard:draw()
	-- draw p1 score top left, draw p2 score top right
	love.graphics.printf(self.p1, 5 * scale, 10 * scale, 0, "left");
	love.graphics.printf(self.p2, width - (5 * scale), 10 * scale, 0, "right");
end

function scoreboard:update(dt)
	-- left to appease main.lua
end

function scoreboard:point(player)
	-- simply, give point to appropriate player
	if (player == 1) then
		self.p1 = self.p1 + 1;
	else
		self.p2 = self.p2 + 1;
	end
end

return scoreboard;