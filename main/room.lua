ROOM = {}
ROOM.__index = ROOM

function ROOM.new(x, y, width, height)
	local newRoom = {}
	setmetatable(newRoom, ROOM)
	newRoom.x = x -- x and y define the bottom left corner of the room
	newRoom.y = y
	newRoom.width = width -- width and height define space between outermost walls of the room
	newRoom.height = height
	return newRoom
end

return ROOM
