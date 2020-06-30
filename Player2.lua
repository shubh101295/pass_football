Player2 = Class{}

local playerImage2 = love.graphics.newImage('team2B.png')

function Player2:init(id , x, y)

	self.id = id
	self.x = x
	self.y = y
	self.height = 25
	self.width = 25
	self.absolute_width = playerImage2:getWidth()
	self.absolute_height = playerImage2:getHeight()
	self.dx=0
	self.dy=0
	self.limit = 2
end

function Player2:collides(box)

	-- return 1 means no collision
	-- return 2 means there is somthing on the left
	-- return 3 means there is something on the right
	-- return 5 means there is something on the top
	-- return 7 means there is something on the bootom 

	if self.x > box.x + box.width +self.limit  or box.x > self.x + self.width +self.limit then
		-- print("a")
		return 1		
	end
	 
	if self.y> box.y + box.height +self.limit or box.y > self.y + self.height +self.limit then
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


function Player2:update(dt,col_value)  -- col_value means collision

	if love.keyboard.isDown('up') and col_value%5 ~= 0 then
		self.dy = -7000 *dt
	end
	if love.keyboard.isDown('down') and col_value%7 ~= 0 then
		self.dy =   7000 *dt
	end
	if love.keyboard.isDown('left') and col_value%2 ~= 0 then
		self.dx = - 7000 * dt
	end
	if love.keyboard.isDown('right') and col_value%3 ~= 0 then
		self.dx = 7000 * dt
	end	
	
	screen_width = 700
	screen_height = 480

--  player doesnot go out of the screen
	if self.y<=0 and self.dy<0 then
		self.dy=0
		self.y=0
	elseif self.y + self.height > VIRTUAL_HEIGHT and self.dy>0 then
		self.dy = 0
		self.y = VIRTUAL_HEIGHT - self.height
	end 
	if self.x<0 and self.dx<0 then
		self.x=0
		self.dx=0
	elseif self.x+ self.width > VIRTUAL_WIDTH and self.dx>0 then
		self.x= VIRTUAL_WIDTH - self.width
		self.dx=0
	end
--	Player
-- updating the position of players
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	self.dx=0
	self.dy=0

	
end	

function Player2:reset(x,y)
	self.x = x
	self.y = y
	self.dx = 0
	self.dy = 0
end


function Player2:render()

	love.graphics.draw(playerImage2 , self.x , self.y , 0, 
		self.height / self.absolute_height , self.width / self.absolute_width )
	

end
