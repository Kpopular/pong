local ent = {};

function ent:draw()
end

function ent:update(dt)
end

function ent:new()
	local tbl = {};
	for k, v in pairs(self) do
		tbl[k] = v;
	end
	return tbl;
end

return ent:new();