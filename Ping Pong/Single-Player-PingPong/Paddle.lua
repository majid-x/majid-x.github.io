Paddle = Class{}

function Paddle:init(x,y,width,height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height

	self.dy = 0
end

function Paddle:update(dt)
	if self.dy < 0 then
		self.y = math.max(0,self.y + self.dy * dt)
	elseif self.dy > 0 then
		self.y = math.min(vheight -20,self.y + self.dy * dt)
	end
end
function Paddle:paddle2(dt,turn)
	if self.dy < 0 and turn ==1 then
		self.y = math.max(0,self.y + self.dy*dt)
	elseif self.dy > 0 and turn == 1 then
		self.y = math.min(vheight -20,self.y + self.dy*dt)
	end
end
function Paddle:render()
	love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
end
