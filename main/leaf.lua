LEAF = {}
LEAF.__index = LEAF

ROOM = require("main.room")
CORRIDOR = require("main.corridor")

function LEAF.new(x, y, width, height)
	local newLeaf = {}
	setmetatable(newLeaf, LEAF)
	newLeaf.x1 = x -- x and y define the bottom left corner of the walls of the leaf
	newLeaf.y1 = y
	newLeaf.width = width -- width and height define space between outermost walls of the leaf
	newLeaf.height = height
	newLeaf.x2 = (x + width + 1)
	newLeaf.y2 = (y + height + 1)
	newLeaf.leftChild = nil -- bottom if split horizontally
	newLeaf.rightChild = nil -- top if split horizontally
	newLeaf.room = nil
	newLeaf.corridor = nil -- corridor connecting this leaf's children
	newLeaf.num = 0
	return newLeaf
end

function LEAF:split(min_size)
	if self.leftChild ~= nil or self.rightChild ~= nil then
		return false
	end

	local horizontal = math.random(0, 1) == 1
	
	if (self.width - min_size) <= min_size then
		horizontal = true
	elseif (self.height - min_size) <= min_size then
		horizontal = false
	end

	local max = (horizontal and self.height or self.width) - min_size
	if max <= min_size then
		return false
	end
	
	local split = math.random(min_size+1, max)
	if horizontal then
		self.leftChild = LEAF.new(self.x1, self.y1, self.width, split - 1)
		self.rightChild = LEAF.new(self.x1, self.y1 + split, self.width, self.height - split)
		self.leftChild.num = self.num + 1
		self.rightChild.num = self.num + 2
	else
		self.leftChild = LEAF.new(self.x1, self.y1, split - 1, self.height)
		self.rightChild = LEAF.new(self.x1 + split, self.y1, self.width - split, self.height)
		self.leftChild.num = self.num + 1
		self.rightChild.num = self.num + 2
	end
	
	return true
end

function LEAF:create_room(min_size, spacing, corridor_size)
	if self.leftChild ~= nil or self.rightChild ~= nil then
		return false
	end
	
	local min_width = math.min(min_size, self.width - (spacing*2))
	local min_height = math.min(min_size, self.height - (spacing*2))

	local width = math.random(min_width, self.width - (spacing*2))
	local height = math.random(min_height, self.height - (spacing*2))

	local x = math.random(self.x1 + 1 + spacing, self.x2 - width - spacing)
	local y = math.random(self.y1 + 1 + spacing, self.y2 - height - spacing)

	local room_center_x = math.floor(x + (width/2))
	local room_center_y = math.floor(y + (height/2))

	local leaf_center_x = math.floor(self.x1 + (self.width/2))
	local leaf_center_y = math.floor(self.y1 + (self.height/2))

	self.room = ROOM.new(x, y, width, height)
	-- self.room.corridor = CORRIDOR.new(leaf_center_x, leaf_center_y, room_center_x, room_center_y, corridor_size)
	-- self.room.corridor.tile = 4
	
	return true
end

function LEAF:connect_children(corridor_size)
	if self.leftChild == nil or self.rightChild == nil then
		return false
	end

	local start_x = math.floor(self.leftChild.x1 + (self.leftChild.width/2))
	local start_y = math.floor(self.leftChild.y1 + (self.leftChild.height/2))
	
	local end_x = math.floor(self.rightChild.x1 + (self.rightChild.width/2))
	local end_y = math.floor(self.rightChild.y1 + (self.rightChild.height/2))

	if self.leftChild.room ~= nil then
		start_y = math.floor(self.leftChild.room.y1 + (self.leftChild.room.height/2))
		start_x = math.floor(self.leftChild.room.x1 + (self.leftChild.room.width/2))
	end
	if self.rightChild.room ~= nil then
		end_y = math.floor(self.rightChild.room.y1 + (self.rightChild.room.height/2))
		end_x = math.floor(self.rightChild.room.x1 + (self.rightChild.room.width/2))
	end

	-- if self.leftChild.x1 == self.rightChild.x1 then
	-- 	if self.leftChild.room ~= nil then
	-- 		start_y = math.floor(self.leftChild.room.y1 + (self.leftChild.room.height/2))
	-- 		start_x = math.floor(self.leftChild.room.x1 + (self.leftChild.room.width/2))
	-- 	end
	-- 	if self.rightChild.room ~= nil then
	-- 		end_y = math.floor(self.rightChild.room.y1 + (self.rightChild.room.height/2))
	-- 		end_x = math.floor(self.rightChild.room.x1 + (self.rightChild.room.width/2))
	-- 	end
	-- elseif self.leftChild.y1 == self.rightChild.y1 then
	-- 	if self.leftChild.room ~= nil then
	-- 		start_x = math.floor(self.leftChild.room.x1 + (self.leftChild.room.width/2))
	-- 	end
	-- 	if self.rightChild.room ~= nil then
	-- 		end_x = math.floor(self.rightChild.room.x1 + (self.rightChild.room.width/2))
	-- 	end
	-- end
	
	self.corridor = CORRIDOR.new(start_x, start_y, end_x, end_y, corridor_size)
	self.corridor.tile = 2
	return true
end

return LEAF
