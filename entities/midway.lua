-- the halfway line
local midway = {};

function midway:draw()
	love.graphics.rectangle("fill", (width / 2) - 5, 0, 10, height);
end

function midway:update()
	-- midway has no update
	-- a method stub has to be here as the main.lua update call expects the ent to have an update
	-- pretty sure a noop has less performance impact than checking if the ent has an update method
end

return midway;