
Ball = Class{}
local ballImage =  love.graphics.newImage('ball.jpeg')


function Ball:init()
	self.x = VIRTUAL_WIDTH/2-12
	self.y= VIRTUAL_HEIGHT/2-12
	self.absolute_width = ballImage:getWidth()
	self.absolute_height = ballImage:getHeight()
	self.height  = 24
	self.width = 24
	self.limit = 2
	self.dx = 0
	self.dy = 0 
end

function Ball:collides(box)
	-- return 1 means no collision
	-- return 2 means there is somthing on the left
	-- return 3 means there is something on the right
	-- return 5 means there is something on the top
	-- return 7 means there is something on the bootom 

	if self.x > box.x + box.width + self.limit  or box.x > self.x + self.width + self.limit then
		-- print("a")
		return 1		
	end
	 
	if self.y> box.y + box.height + self.limit or box.y > self.y + self.height + self.limit then
		-- print("B")
		return 1
	end
	-- print(self.x , self.y , box.x , box.y) 
	-- print(self.width , self.height , box.width , box.height)
	-- print("C")

	-- if we reach here in the code we guarantee that there is a collision 
	if self.x + self.width   <= box.x then 
		return 3
	end 
	if box.x + box.width  <= self.x then
		return 2
	end
	if self.y + self.height  <= box.y then
		return 7
	end
	return 5
	
end

function Ball:update(dt , col_value)
	self.dx = 0
	self.dy = 0
	if col_value%6 ~= 0 then
		if col_value % 3 == 0 then
			self.dx = -100 *dt
		elseif col_value % 2 == 0 then
			self.dx = 100 * dt
		end
	end

	if col_value%35 ~= 0 then
		if col_value % 5 == 0 then
			self.dy = 100 *dt
		elseif col_value % 7 == 0 then
			self.dy = -100 * dt
		end
	end


	
	self.x = math.max( 25 , math.min(VIRTUAL_WIDTH - self.width -25 , self.x + self.dx))
	-- self.y = self.y + self.dy

	self.y = math.max( 30 , math.min(VIRTUAL_HEIGHT - self.height - 30 , self.y + self.dy))
	

end

function Ball:reset()
	self.x = VIRTUAL_WIDTH/2-12
	self.y= VIRTUAL_HEIGHT/2-12
	self.dx = 0
	self.dy = 0
end 

function Ball:render()
	love.graphics.draw(ballImage, self.x, self.y ,
		0 , 24/self.absolute_height,24/self.absolute_width)
end
