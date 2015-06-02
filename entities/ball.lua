local ball = {};

function ball:ctor(scoreboard)
	self.size = 5 * scale;
	self.w = self.size; -- w/h only needed for collision check
	self.h = self.size;
	self.x = (width / 2) - (self.size / 2);
	self.y = (height / 2) - (self.size / 2);
	self.xvel = 0;
	self.yvel = 0;
	self.colour = 204;
	self.speed = 100 * scale;
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
	self:boundsCheck();
	self:collisionCheck();
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
		self.scoreboard:point(2);
		self:start();
	elseif (self.x > (width - self.size)) then -- right bounds
		self.scoreboard:point(1);
		self:start();
	end
	
end

function ball:collisionCheck()
	if (self:collisionTest(self, ents['player1'])) then
		self.xvel = self.xvel - self.xvel - self.xvel;
		self.x = ents['player1'].x + ents['player1'].w + 1;
		
		local xvel1 = self.xvel;
		local yvel1 = self.yvel;
		
		if self.y < ((ents['player1'].centerH / 2) + ents['player1'].y) then
			self:goto(width, 0);
			print('top');
		elseif self.y > ((ents['player1'].h + ents['player1'].y) - (ents['player1'].h / 4)) then
			self:goto(width, height);
			print('bot');
		else
			self:goto(width, height / 2);
			print('mid');
		end
		
		local xvel2 = self.xvel;
		local yvel2 = self.yvel;
		
		self.xvel = (xvel1 + xvel2) / 2;
		self.yvel = (yvel1 + yvel2) / 2;
	end
	
	if (self:collisionTest(self, ents['player2'])) then
		self.xvel = self.xvel - self.xvel - self.xvel;
		self.x = ents['player2'].x - ents['player2'].w - 1;
		
		local xvel1 = self.xvel;
		local yvel1 = self.yvel;
		
		if self.y < ((ents['player2'].centerH / 2) + ents['player2'].y) then
			self:goto(0, 0);
			print('top');
		elseif self.y > ((ents['player2'].h + ents['player2'].y) - (ents['player2'].h / 4)) then
			self:goto(0, height);
			print('bot');
		else
			self:goto(0, height / 2);
			print('mid');
		end
		
		local xvel2 = self.xvel;
		local yvel2 = self.yvel;
		
		self.xvel = (xvel1 + xvel2) / 2;
		self.yvel = (yvel1 + yvel2) / 2;
	end
	--[[if (self:collisionTest(self, ents['player2'])) then
		player = ents['player2'];
		self.xvel = self.xvel - self.xvel - self.xvel;
		self.x = player.x - player.w - 1;
	end
	
	if (collide) then
		local xvel1 = self.xvel;
		local yvel1 = self.yvel;
		
		if self.y < ((player.centerH / 2) + player.y) then
			self:goto(width, 0);
			print('top');
		elseif self.y > ((player.h + player.y) - (player.centerH / 2)) then
			self:goto(width, height);
			print('bot');
		else
			self:goto(width, height / 2);
			print('mid');
		end
		
		local xvel2 = self.xvel;
		local yvel2 = self.yvel;
		
		self.xvel = (xvel1 + xvel2) / 2;
		self.yvel = (yvel1 + yvel2) / 2;
	end--]]
end

function ball:collisionTest(box1, box2)
	return box1.x < box2.x + box2.w and 
		   box1.x + box1.w > box2.x and
		   box1.y < box2.y + box2.h and
		   box2.y < box1.y + box1.h
end

return ball;