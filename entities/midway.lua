local midway = {};

function midway:draw()
	-- consider making a dashed line algorithm
	love.graphics.rectangle("fill", (width / 2) - 5, 0, 10, height);
end

function midway:update()
	--midway has no update
end

return midway;