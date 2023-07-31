Ball = Class{}

function Ball:init(x,y,width,height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.dx = math.random(2) == 1 and -300 or 300
	self.dy = math.random(-150,150)
end
function Ball:collide(box)
	if self.x> box.x + box.width or self.x + self.width < box.x then
		return false
	end
	if self.y> box.y + box.height or self.y + self.height < box.y then
		return false
	end

	return true
end
function Ball:reset()
	self.x = vwidth/2-2
	self.y = vheight/2-2
	self.dx = math.random(2) == 1 and -300 or 300
	self.dy = math.random(-150,150)
end

function Ball:update(dt)
	self.x = self.x + self.dx*dt
	self.y = self.y + self.dy*dt
end

function Ball:render()
	love.graphics.rectangle('fill',self.x,self.y,4,4)
end