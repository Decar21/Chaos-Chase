keys = {}

function keys.move(up, down, left, right, speed)
	if love.keyboard.isDown(up)
		Ship.y = Ship.y - shipSpeeed
	end

	if love.keyboard.isDown(down)
		Ship.y = Ship.y + shipSpeeed
	end

	if love.keyboard.isDown(left)
		Ship.x = Ship.x - shipSpeeed
	end

	if love.keyboard.isDown(right)
		Ship.x = Ship.x + shipSpeeed
	end
end