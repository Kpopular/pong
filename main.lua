function love.load()
	scale = 1;
	width, height = love.window.getDimensions();
	scale = love.window.getPixelScale();
	-- other init here
end

function love.draw()
	-- draw
end

function love.update(dt)
	-- update
end

function love.keypressed(key)
	if (key == "escape") then
		love.event.quit();
	end
end

function love.keyreleased(key)

end

function love.mousepressed(x, y, btn)

end

function love.mousereleased(x, y, btn)

end