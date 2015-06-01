local paddle = {};

function paddle:factory()
	local tbl = {};
	for k, v in pairs(paddle) do
		tbl[k] = v;
	end
	return tbl;
end

function paddle:ctor(player, ai)
	self.player = player or 1;
	self.w = 10 * scale;
	self.h = 40 * scale;
	if (self.player == 1) then
		self.x = 10 * scale;
	else
		self.x = width - self.w - (10 * scale);
	end
	self.y = (height / 2) - 20;
	self.dir = 0; -- 0 = up, 1 = down
	self.speed = 100;
	self.ai = ai or false;
end

function paddle:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h);
end

function paddle:update(dt)
	
end

return paddle;