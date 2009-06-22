print("Welcome to the test game")

open_door = function(dirstring)
	if not data.rooms then
		print("You open the door and take your first step into the unknown, unless you played this game before.")
		data.rooms = {}
		data.playerx = 1
		data.playery = 1
	elseif dirstring == "n" then
		data.playery = data.playery+1
	elseif dirstring == "s" then
		data.playery = data.playery-1
	elseif dirstring == "e" then
		data.playerx = data.playerx+1
	elseif dirstring == "w" then
		data.playerx = data.playerx-1
	else
		print("Usage: go [n,s,e,w]")
		return
	end


	if not data.rooms[data.playerx] then
		data.rooms[data.playerx] = {}
	end
	if not data.rooms[data.playerx][data.playery] then
		print("You explore a new room")
		data.rooms[data.playerx][data.playery] = {}
		room = data.rooms[data.playerx][data.playery]
		room.monsters = {}
		monster = {level=math.random(20)}
		table.insert(room.monsters, monster)
	end
	room = data.rooms[data.playerx][data.playery]
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

	end
	if cmd:sub(1,4) == "flee" then
		print("You run away to face this at a better time.")
		open_door(cmd:sub(6))
		command_handlers["fight"] = nil
		command_handlers["explore"] = data.explore_cmd_handler
	end
	if cmd == "commands" then
		print("fight, flee")
	end
end

data.explore_cmd_handler = function(cmd)
	if cmd:sub(1,2) == "go" then
		open_door(cmd:sub(4))
	end
	if cmd == "commands" then
		print("go")
	end
end

command_handlers["explore"] = data.explore_cmd_handler

