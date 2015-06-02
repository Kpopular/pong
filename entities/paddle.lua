local paddle = {};

function paddle:factory()
	-- crude "instantiator" method, for getting 2 paddle instances
	local tbl = {};
	for k, v in pairs(paddle) do
		tbl[k] = v;
	end
	return tbl;
end

function paddle:ctor(player, ai)
	-- setup this player
	-- player param defines which side of the field the player is on (1 = left "player one", 2 = right "player 2")
	-- ai true or false: if true, this player is ai controlled
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
	self.speed = 100 * scale;
	self.ai = ai or false;
	self.ai_data = {}; -- table to stash the ai's "thoughts"
	self.centerW = self.w / 2;
	self.centerH = self.h / 2;
end

function paddle:draw()
	-- draw the paddle at an appropriate location
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h);
end

function paddle:update(dt)
	
	local offset = self.target - self.centerH; -- where we want to go, aimed from center of paddle
	local near_target = math.abs(offset - self.y) < 1; -- y coord within 1 pixel of target, because the movement is never going to get to a precise point on its own
	
	if (near_target) then
		self.y = offset; -- set the y coord to the precise target to stop the paddle spasming around the target point because of imprecision
	else
		if (offset > self.y) then -- if target is above me, move up - else move down
			self.y = self.y + (self.speed * dt);
		elseif (offset < self.y) then
			self.y = self.y - (self.speed * dt);
		end
	end
	
	if self.ai then
		-- "ai"
		
		self.ai_data.last_action = self.ai_data.last_action or 0; -- initialise last time i did something to 0ms (aka never)
		self.ai_data.idle = self.ai_data.idle or 0; -- initialise how long i should wait to do something to 0ms (aka right now)
		
		if self.ai_data.last_action > self.ai_data.idle then -- if i've waited long enough to take an action
			-- update my information: note where the ball was last cycle, and where it is now
			self.ai_data.ball_last_x = self.ai_data.ball_x or ents['ball'].x;
			self.ai_data.ball_x = ents['ball'].x;
			self.ai_data.ball_y = ents['ball'].y;
			
			if(self.ai_data.ball_x > self.ai_data.ball_last_x) then -- ball is coming towards me
				-- guess where it's going to land with a margin of randomness
				-- the margin of error is quite big, especially given the calculation originates from the top of the paddle
				-- meaning the guess is wrong just as often as it is right
				-- when the game is running, this winds up in skillful edge shots as well as stupid errors
				-- i feel that, while rudimentary, it's probably an accurate representation of a novice player because let's face it - pong's not that hard
				local margin = love.math.random(0, self.h * scale); -- margin for error - set to the area around the paddle, simulates trying to get edge shots/bad plays
				local coin = love.math.random(1, 100); -- whether to use the margin for error as an addition to where the ball is, or a subtraction
				if (coin < 50) then
					self:input(self.ai_data.ball_y - margin);
				else
					self:input(self.ai_data.ball_y + margin);
				end
			end
			
			self.ai_data.last_action = 0; -- set the last time i took an action to now
			self.ai_data.idle = love.math.random(); -- randomise a time to take next action to simulate "thinking"
		else
			self.ai_data.last_action = self.ai_data.last_action + dt;
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