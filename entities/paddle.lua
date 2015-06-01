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
	self.target = (height / 2);
	self.speed = 100;
	self.ai = ai or false;
	self.centerW = self.w / 2;
	self.centerH = self.h / 2;
end

function paddle:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h);
end

function paddle:update(dt)

	local offset = self.target - self.centerH; -- target aimed from center
	local near_target = math.abs(offset - self.y) < 1; -- y coord within 1 pixel of target
	
	if (near_target) then
		self.y = offset; -- set the y coord to the precise target
	else
		if (offset > self.y) then
			self.y = self.y + (self.speed * dt);
		elseif (offset < self.y) then
			self.y = self.y - (self.speed * dt);
		end
	end
end

function paddle:input(y)
	
	-- receive player's y input coord
	-- make sure the input coord wouldnt put us out of bounds
	
	if (y < self.centerH) then -- if player input is less than center height, would be out of top bounds
		self.target = self.centerH + 1;
	elseif (y > (height - self.centerH)) then -- out of bottom bounds
		self.target = height - self.centerH - 1;
	else
		self.target = y;
	end
end

return paddle;