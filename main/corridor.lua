CORRIDOR = {}
CORRIDOR.__index = CORRIDOR

function CORRIDOR.new(x1, y1, x2, y2, size)
	local newCorridor = {}
	setmetatable(newCorridor, CORRIDOR)
	newCorridor.x1 = x1 -- starting x and y
	newCorridor.y1 = y1
	newCorridor.x2 = x2 -- ending x and y
	newCorridor.y2 = y2
	newCorridor.size = size
	newCorridor.tile = 1
	return newCorridor
end

function CORRIDOR:draw_corridor(tilemap, CORRIDORS)
	local ix = (self.x2 - self.x1) >= 0 and 1 or -1
	local iy = (self.y2 - self.y1) >= 0 and 1 or -1

	if math.random(0, 1) == 1 then
		for x=self.x1,self.x2,ix do
			tilemap.set_tile("#map", CORRIDORS, x, self.y1, self.tile)
		end

		for y=self.y1,self.y2,ix do
			tilemap.set_tile("#map", CORRIDORS, self.x2, y, self.tile)
		end
	else
		for y=self.y1,self.y2,ix do
			tilemap.set_tile("#map", CORRIDORS, self.x1, y, self.tile)
		end

		for x=self.x1,self.x2,ix do
			tilemap.set_tile("#map", CORRIDORS, x, self.y2, self.tile)
		end
	end
end

return CORRIDOR
