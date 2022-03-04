Leaf = {}
Leaf.__index = Leaf

function Leaf.new(x, y, width, height)
	local newLeaf = {}
	setmetatable(newLeaf, Leaf)
	newLeaf.x = x -- x and y define the bottom left corner of the room
	newLeaf.y = y
	newLeaf.width = width
	newLeaf.height = height
	newLeaf.leftChild = nil
	newLeaf.rightChild = nil
	return newLeaf
end

function Leaf:split(min_size)
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
	
	local split = math.random(min_size, max)
	if horizontal then
		self.leftChild = Leaf.new(self.x, self.y, self.width, split)
		self.rightChild = Leaf.new(self.x, self.y + split, self.width, self.height - split)
	else
		self.leftChild = Leaf.new(self.x, self.y, split, self.height)
		self.rightChild = Leaf.new(self.x + split, self.y, self.width - split, self.height)
	end
	
	return true
end

return Leaf