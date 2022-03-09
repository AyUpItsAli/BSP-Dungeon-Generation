ROOM = {}
ROOM.__index = ROOM

function ROOM.new(x, y, width, height)
	local newRoom = {}
	setmetatable(newRoom, ROOM)
	newRoom.x1 = x -- x and y define the bottom left corner of the space inside the room
	newRoom.y1 = y
	newRoom.width = width -- width and height define space between outermost walls of the room
	newRoom.height = height
	newRoom.x2 = (x + width - 1)
	newRoom.y2 = (y + height - 1)
	newRoom.tile = 2
	newRoom.corridor = nil
	return newRoom
end

return ROOM
