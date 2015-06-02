-- the ball!
-- as much as i tried to adhere to strict-ish oop for this game, the ball breaks a lot of rules
-- it has direct access to the ents (because they're global), it tells the scoreboard that a point happened,
-- it controls its own respawning when it collides with a goal point
-- it controls its own movement based on what it collided with
-- a big chunk of the actual game is in this object
-- i'm not proud of that, but this is why we make practice software
local ball = {};

function ball:ctor(scoreboard)
	self.size = 5 * scale; -- change the size of the ball based on the pixel scale (visual consistency on mobile)
	self.w = self.size; -- w/h only needed for collision check
	self.h = self.size;
	self.x = (width / 2) - (self.size / 2); -- placing the ball dead center of the screen
	self.y = (height / 2) - (self.size / 2);
	self.xvel = 0; -- start with a velocity of 0
	self.yvel = 0;
	self.colour = 204; -- make it greyish instead of white, because reasons
	self.speed = 125 * scale; -- without the scale, the ball moves incredibly slow on high resolution devices
	self.scoreboard = scoreboard; -- pretending to adhere to oop - in reality we could just call ents['scoreboard'] and it'd work just fine, because i am a lazy dev

	self:start(); -- start doing the things we're meant to do, like move
end

function ball:start()
	-- set the position to midfield - already there on first run, but when the ball wants to restart the game...
	self.x = (width / 2) - (self.size / 2);
	self.y = (height / 2) - (self.size / 2);
	
	local rnd = love.math.random(1, 100); -- decide which side of the screen to aim at
	-- pretty sure the way i've done it isn't a perfect 50/50 split in odds, but it's close enough

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
	love.graphics.setColor(255, 255, 255); -- always reset the colour, otherwise everything is drawn shaded - which, while neat at times, is not what we want here
end

function ball:update(dt)
	-- keep right on moving along
	self.x = self.x + (self.xvel * dt);
	self.y = self.y + (self.yvel * dt);
	
	-- once we've moved, check if we've hit the roof or floor of the screen
	self:boundsCheck();
	
	-- after we've checked that we're in bounds, see if we've hit a player or goal zone
	self:collisionCheck();
end

function ball:goto(x, y)
	-- used to aim the ball at a specific point
	local startX = self.x + self.size / 2;
	local startY = self.y + self.size / 2;
	local angle = math.atan2((y - startY), (x - startX));
	self.xvel = self.speed * math.cos(angle);
	self.yvel = self.speed * math.sin(angle);
end

function ball:boundsCheck()
	-- if hit top or bottom, invert y - simulates bouncing off the wall
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
		-- if i hit player 1, bounce away from player one
		-- flip my x velocity around so i go in the other direction
		-- set my location to just next to player 1 so i dont re-trigger the collision check
		self.xvel = self.xvel - self.xvel - self.xvel;
		self.x = ents['player1'].x + ents['player1'].w + 1;
		
		-- make a note of where i'm going at the moment
		local xvel1 = self.xvel;
		local yvel1 = self.yvel;
		
		
		if self.y < ((ents['player1'].centerH / 2) + ents['player1'].y) then -- if i hit the top third-ish of the paddle
			self:goto(width, 0); -- aim at the top right corner of the screen
		elseif self.y > ((ents['player1'].h + ents['player1'].y) - (ents['player1'].h / 4)) then -- if i hit the bottom third-ish of the paddle
			self:goto(width, height); -- aim at the bottom right corner of the screen
		else -- if i hit the middle of the paddle
			self:goto(width, height / 2); -- aim at the center of the other goal zone
		end
		
		-- re-aim myself at a point somewhere between where i was first aiming, and where i'm now aiming
		-- this allows the players to simulate spin/edge shots by influencing the angle i move at
		
		local xvel2 = self.xvel;
		local yvel2 = self.yvel;
		
		self.xvel = (xvel1 + xvel2) / 2;
		self.yvel = (yvel1 + yvel2) / 2;
	end
	
	if (self:collisionTest(self, ents['player2'])) then -- check if i hit player 2 - do the same as if i hit player 1, but reverse the directions/anchors
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
end

function ball:collisionTest(box1, box2)
	-- simple way to tell if one ent is colliding with another ent
	-- returns true/false. good if you want to know that collision is happening, but dont care about how/who/where/etc
	return box1.x < box2.x + box2.w and 
		   box1.x + box1.w > box2.x and
		   box1.y < box2.y + box2.h and
		   box2.y < box1.y + box1.h
end

return ball;