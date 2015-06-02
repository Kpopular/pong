local ball = {};

function ball:ctor(scoreboard)
	self.size = 5 * scale;
	self.x = (width / 2) - (self.size / 2);
	self.y = (height / 2) - (self.size / 2);
	self.xvel = 0;
	self.yvel = 0;
	self.colour = 204;
	self.speed = 100;
	self.scoreboard = scoreboard;

	self:start();
end

function ball:start()
	self.x = (width / 2) - (self.size / 2);
	self.y = (height / 2) - (self.size / 2);
	
	local rnd = love.math.random(1, 100);

	if (rnd > 50) then
		-- aim at AI
		self:goto(width, love.math.random(height));
	else
		-- aim at player
		self:goto(0, love.math.random(height));
	end
end

function ball:draw()
	love.graphics.setColor(self.colour, self.colour, self.colour);
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size);
	love.graphics.setColor(255, 255, 255);
end

function ball:update(dt)
	self.x = self.x + (self.xvel * dt);
	self.y = self.y + (self.yvel * dt);
	
	-- need bounds check
	self:boundsCheck();
	-- need collision test
end

function ball:goto(x, y)
	local startX = self.x + self.size / 2;
	local startY = self.y + self.size / 2;
	local angle = math.atan2((y - startY), (x - startX));
	self.xvel = self.speed * math.cos(angle);
	self.yvel = self.speed * math.sin(angle);
end

function ball:boundsCheck()

	-- if hit top or bottom, invert y
	-- if hit left, point for p1
	-- if hit right, point for p2
	if (self.y < 1) then -- top bounds
		self.y = 1;
		self.yvel = self.yvel - self.yvel - self.yvel;
	elseif (self.y > (height - self.size)) then -- bot bounds
		self.y = (height - self.size - 1);
		self.yvel = self.yvel - self.yvel - self.yvel;
	end
	
	if (self.x < 1) then -- left bounds
		self.scoreboard:point(1);
		self:start();
	elseif (self.x > (width - self.size)) then -- right bounds
		self.scoreboard:point(2);
		self:start();
	end
	
end

return ball;