local ball = {};

function ball:ctor()
	ball.size = 5 * scale;
	ball.x = (width / 2) - (ball.size / 2);
	ball.y = (height / 2) - (ball.size / 2);
	ball.xvel = 0;
	ball.yvel = 0;
	ball.colour = 204;
	ball.speed = 100;

	local rnd = love.math.random(1, 100);

	if (rnd > 50) then
		-- aim at AI
		ball:goto(width, love.math.random(height));
	else
		-- aim at player
		ball:goto(0, love.math.random(height));
	end
end

function ball:draw()
	love.graphics.setColor(ball.colour, ball.colour, ball.colour);
	love.graphics.rectangle("fill", self.x, self.y, self.size, self.size);
	love.graphics.setColor(255, 255, 255);
end

function ball:update(dt)
	self.x = self.x + (self.xvel * dt);
	self.y = self.y + (self.yvel * dt);
	
	-- need bounds check
end

function ball:goto(x, y)
	local startX = self.x + self.size / 2;
	local startY = self.y + self.size / 2;
	local angle = math.atan2((y - startY), (x - startX));
	self.xvel = self.speed * math.cos(angle);
	self.yvel = self.speed * math.sin(angle);
end

return ball;