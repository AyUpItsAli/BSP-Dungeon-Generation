LEAF = {}
LEAF.__index = LEAF

ROOM = require("main.room")

function LEAF.new(x, y, width, height)
	local newLeaf = {}
	setmetatable(newLeaf, LEAF)
	newLeaf.x = x -- x and y define the bottom left corner of the leaf
	newLeaf.y = y
	newLeaf.width = width -- width and height define space between outermost walls of the leaf
	newLeaf.height = height
	newLeaf.leftChild = nil
	newLeaf.rightChild = nil
	newLeaf.room = nil
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
		self.leftChild = LEAF.new(self.x, self.y, self.width, split - 1)
		self.rightChild = LEAF.new(self.x, self.y + split, self.width, self.height - split)
	else
		self.leftChild = LEAF.new(self.x, self.y, split - 1, self.height)
		self.rightChild = LEAF.new(self.x + split, self.y, self.width - split, self.height)
	end
	
	return true
end

function LEAF:create_room(min_size, spacing)
	if self.leftChild ~= nil or self.rightChild ~= nil then
		return false
	end
	
	local min_width = math.min(min_size, self.width - (spacing*2))
	local min_height = math.min(min_size, self.height - (spacing*2))

	local width = math.random(min_width, self.width - (spacing*2))
	local height = math.random(min_height, self.height - (spacing*2))

	local x = math.random(self.x + 1 + spacing, (self.x + self.width + 1) - width - spacing)
	local y = math.random(self.y + 1 + spacing, (self.y + self.height + 1) - height - spacing)

	self.room = ROOM.new(x, y, width, height)
	return true
end

return LEAF
