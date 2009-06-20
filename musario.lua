
commands = {}
data = {}

commands["apple"] = function()
   print("You have executed the command \"apple\"")
end

Save = function(filename)
   print("Saving to file \"" .. filename .. "\"")
end

Load = function(filename)
   print("Loading file \"" .. filename .. "\"")
   data = {}
   commands = {}
end

New_game = function(filename)
   print("Starting game \"" .. filename .. "\"")
   data = {}
   commands = {}
end

while true do
   print("Enter a command, or help")
   cmd = io.stdin:read'*l'
   if cmd == "quit" or cmd == "exit" or cmd == "q" then
      break
   
   elseif cmd == "help" then
      print("To start a new game type new game [script]")
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
