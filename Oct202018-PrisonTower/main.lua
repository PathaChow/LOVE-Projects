-- libs
Class = require 'libs/class'
-- classes
Object = Class{
	init = function(self, x, y, sprite)
		self.x = x
		self.y = y
		self.sprite = sprite
		self.w = sprite:getWidth()
		self.h = sprite:getHeight()
	end,

	draw = function(self)
		love.graphics.draw(self.sprite, self.x, self.y)
	end
}
--block
bar = Class{
	__includes = Object,
    
    init = function(self, x, y, sprite, id)
    	Object.init(self, x, y, sprite)
    	self.id = id
    end
}
--player
player = Object(10, 500, love.graphics.newImage('assets/player.png'))
player.hp = 10
player.update = function(self)
	local dx, dy =0, 0

	if love.keyboard.isDown('left') and self.hp>0 then dx = dx-1 end
	if love.keyboard.isDown('right') and self.hp>0 then dx = dx+1 end
	if love.keyboard.isDown('up') and self.hp>0 then dy = dy-1 end
	if love.keyboard.isDown('down') and self.hp>0 then dy = dy+1 end


	local spd = 5
	self.x = self.x+dx*spd
	self.y = self.y+dy*spd
end
--gate
gate = Object(500, 10, love.graphics.newImage('assets/1.png'))


function love.load()
	light = 0
	counter=0
	flashlights = 10
	love.graphics.setBackgroundColor(0, 0, 0)
	love.graphics.setNewFont('assets/orangekid.ttf',48)
	math.randomseed(os.time())
	bars = {
		bar(10,10,love.graphics.newImage('assets/bar.png'),1)
	}
	--while i<30 do
		--table.insert(bars, bar(math.random(-400, 400), math.random(800),love.graphics.newImage('assets/bar.png'),i+1))
		--i=i+1
	--end
	table.insert(bars, bar(100, 100,love.graphics.newImage('assets/bar.png'),2))
	table.insert(bars, bar(200, 230,love.graphics.newImage('assets/bar.png'),3))
	table.insert(bars, bar(300, 360,love.graphics.newImage('assets/bar.png'),4))
	table.insert(bars, bar(400, 490,love.graphics.newImage('assets/bar.png'),5))
	bgm = love.audio.newSource('assets/pastorale.mp3', 'stream')
	bgm:setLooping(true)
	love.audio.play(bgm)
end

function love.update(dt)
	player:update()
	--check hp
	for i=1, #bars do
		if overlap(player, bars[i]) then
			player.hp = player.hp-1
			if player.hp==0 then
				player.sprite = love.graphics.newImage('assets/0.png')
			end
		end
	end
	--check win
	if overlap(player, gate) then
		player.sprite = love.graphics.newImage('assets/2.png')
	end
	--check light
	if light==1 then
		counter = counter+1;
	end
	if counter==30 then
		counter=0
		love.graphics.setBackgroundColor(0, 0, 0)
	end
end

function love.draw()
	for i=1, #bars do
		bars[i]:draw()
	end
	player:draw()
	gate:draw()
end

function love.keypressed(k)
	if k=='l' and flashlights>0 then
		love.graphics.setBackgroundColor(1, 1, 1)
		light=1
		flashlights= flashlights-1
	end
end

-- util
function overlap(a, b) return a.x < b.x + b.w and a.x + a.w > b.x and a.y < b.y + b.h and a.y + a.h > b.y end
