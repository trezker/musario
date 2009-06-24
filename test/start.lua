print("Welcome to the test game")

data.rooms = {}
data.rooms[0] = {}
data.rooms[0][0] = {}
data.rooms[0][0].monsters = {}


data.player = {}
data.player.level = 1
data.player.health = 4
data.player.x = 0
data.player.y = 0

can_move = function(dirstring)
	if not data.rooms then
--		print("You open the door and take your first step into the unknown, unless you played this game before.")
--		data.rooms = {}
--		data.playerx = 1
--		data.playery = 1
	elseif dirstring == "n" then
--		data.playery = data.playery+1
	elseif dirstring == "s" then
--		data.playery = data.playery-1
	elseif dirstring == "e" then
--		data.playerx = data.playerx+1
	elseif dirstring == "w" then
--		data.playerx = data.playerx-1
	else
		return false
	end
	return true
end


open_door = function(dirstring)
	if not data.rooms then
		print("You open the door and take your first step into the unknown, unless you played this game before.")
		data.rooms = {}
		data.player = {}
		data.player.level = 1
		data.player.health = 4
		data.player.x = 1
		data.player.y = 1
	elseif dirstring == "n" then
		data.player.y = data.player.y+1
	elseif dirstring == "s" then
		data.player.y = data.player.y-1
	elseif dirstring == "e" then
		data.player.x = data.player.x+1
	elseif dirstring == "w" then
		data.player.x = data.player.x-1
	else
		print("Illegal move")
		return
	end


	if not data.rooms[data.player.x] then
		data.rooms[data.player.x] = {}
	end
	if not data.rooms[data.player.x][data.player.y] then
		print("You explore a new room")
		data.rooms[data.player.x][data.player.y] = {}
		room = data.rooms[data.player.x][data.player.y]
		room.monsters = {}
		monster = {level=math.random(20)}
		table.insert(room.monsters, monster)
	end
	room = data.rooms[data.player.x][data.player.y]
	for k, v in pairs(room.monsters) do
		print("You face a level " .. v.level .. " monster.")
	end
	if table.getn(room.monsters) > 0 then
		command_handlers["fight"] = data.fight_cmd_handler
		command_handlers["explore"] = nil
	end
end

data.fight_cmd_handler = function(cmd)
	if cmd:sub(1,5) == "fight" then
		killed_monsters = {}
		surviving_monsters = {}
		for k, v in pairs(room.monsters) do
			player_attack = math.random(6) + data.player.level
			monster_attack = math.random(6) + v.level
			if player_attack > monster_attack then
				print("You kill the monster")
				table.insert(killed_monsters, v)
				data.player.level = data.player.level + 1
			else
				print("The monster bested you")
				data.player.health = data.player.health - 1
				table.insert(surviving_monsters, v)
			end
			room.monsters = surviving_monsters
			if table.getn(room.monsters) > 0 then
				--Some monster survived, player must flee
				while not can_move(cmd) do
					print("You must flee from the remaining monsters. Type n, s, w or e")
					cmd = io.stdin:read'*l'
				end
				command_handlers["fight"] = nil
				command_handlers["explore"] = data.explore_cmd_handler
				open_door(cmd)
			else
				print("Well done, you cleared the room.")
				command_handlers["fight"] = nil
				command_handlers["explore"] = data.explore_cmd_handler
			end
		end
	end
	if cmd:sub(1,4) == "flee" then
		if not can_move(cmd:sub(6)) then
			print("Usage: flee [n,s,e,w]")
		else
			print("You run away to face this at a better time.")
			if math.random(6) >= 5 then
				print("But you take a hit from the monster on your way out.")
				data.player.health = data.player.health - 1
			end
			command_handlers["fight"] = nil
			command_handlers["explore"] = data.explore_cmd_handler
			open_door(cmd:sub(6))
		end
	end
	if cmd == "commands" then
		print("fight, flee")
	end
end

data.explore_cmd_handler = function(cmd)
	if cmd:sub(1,2) == "go" then
		if not can_move(cmd:sub(4)) then
			print("Usage: go [n,s,e,w]")
		else
			open_door(cmd:sub(4))
		end
	end
	if cmd == "commands" then
		print("go")
	end
end

data.info_cmd_handler = function(cmd)
	if cmd == "level" then
		print("Your level is " .. data.player.level)
	elseif cmd == "position" then
		print("This room is at " .. data.player.x .. ":" .. data.player.y)
	elseif cmd == "health" then
		print("Your health is " .. data.player.health)
	end
end

command_handlers["info"] = data.info_cmd_handler
command_handlers["explore"] = data.explore_cmd_handler

