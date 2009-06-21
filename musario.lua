main = function()
	commands = {}
	data = {}

	while true do
		print("Enter a command, or help")
		cmd = io.stdin:read'*l'
		if cmd == "quit" or cmd == "exit" or cmd == "q" then
		   break
		
		elseif cmd == "help" then
		   print("To start a new game type new game [game folder]")
		   print("To load a saved game type load [filename]")
		   print("To save, type save [filename]")
		   print("Type commands to see available non-secret commands")
		   print("Type quit, exit or q to quit")

		elseif cmd == "commands" then
		   for k, v in pairs(commands) do
		      print(k)
		   end

		elseif cmd:sub(1, 4) == "save" then
		   Save(cmd:sub(6))

		elseif cmd:sub(1, 4) == "load" then
		   Load(cmd:sub(6))

		elseif cmd:sub(1, 8) == "new game" then
		   New_game(cmd:sub(10))

		else
		   if commands[cmd] then
		      commands[cmd]()
		   end
		end
	end
end

Save = function(filename)
   print("Saving to file \"" .. filename .. "\"")
   f = io.open("savefiles/" .. filename, "w")
   Save_data("data", data)
   Save_data("commands", commands)
   f:close()
end

Load = function(filename)
   print("Loading file \"" .. filename .. "\"")
   data = {}
   commands = {}
   dofile("savefiles/" .. filename)
end

New_game = function(filename)
   print("Starting game \"" .. filename .. "\"")
   data = {}
   commands = {}
   dofile(filename .. "/start.lua")
end

function exportstring( s )
   s = string.format( "%q",s )
   -- to replace
   s = string.gsub( s,"\\\n","\\n" )
   s = string.gsub( s,"\r","\\r" )
   s = string.gsub( s,string.char(26),"\"..string.char(26)..\"" )
   return s
end

function basicSerialize (o)
	if type(o) == "number" then
		return tostring(o)
	else   -- assume it is a string
		return string.format("%q", o)
	end
end

function Save_data (name, value, saved)
	saved = saved or {}       -- initial value
--	io.write(name, " = ")
	f:write(name, " = ")
	if type(value) == "number" or type(value) == "string" then
	--	io.write(basicSerialize(value), "\n")
		f:write(basicSerialize(value), "\n")
	elseif type(value) == "function" then
		f:write("loadstring("..exportstring(string.dump( value ))..")")
	elseif type(value) == "table" then
		if saved[value] then    -- value already saved?
		--	io.write(saved[value], "\n")  -- use its previous name
			f:write(saved[value], "\n")
		else
			saved[value] = name   -- save name for next time
			--io.write("{}\n")     -- create a new table
			f:write("{}\n")     -- create a new table
			for k,v in pairs(value) do      -- save its fields
				local fieldname = string.format("%s[%s]", name,
			                       basicSerialize(k))
				Save_data(fieldname, v, saved)
			end
		end
	else
		error("cannot save a " .. type(value))
	end
end


main()
