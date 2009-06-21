print("Welcome to the test game")

table.insert(commands, "open door")

open_door = function()
	if not data.rooms then
		print("You open the door and take your first step into the unknown, unless you played this game before.")
		data.rooms = {}
		data.playerx = 1
		data.playery = 1
	end

	if not data.rooms[data.playerx] then
		data.rooms[data.playerx] = {}
	end
	data.rooms[data.playerx][data.playery] = {}
end

explore_cmd_handler = function(cmd)
	if cmd:sub(1,9) == "open door" then
		open_door()
	end
end

command_handlers["explore"] = explore_cmd_handler
