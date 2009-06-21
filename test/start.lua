print("Welcome to the test game")

table.insert(commands, "open door")

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
		print("Usage: open door [n,s,e,w]")
	end


	if not data.rooms[data.playerx] then
		data.rooms[data.playerx] = {}
	end
	if not data.rooms[data.playerx][data.playery] then
		print("You explore a new room")
		data.rooms[data.playerx][data.playery] = {}
		room = data.rooms[data.playerx][data.playery]
	end
end

explore_cmd_handler = function(cmd)
	if cmd:sub(1,9) == "open door" then
		open_door(cmd:sub(11))
	end
end

command_handlers["explore"] = explore_cmd_handler
