-- opening rednet
peripheral.find("modem", rednet.open)
term.clear()
-- loop forever
while true do
    -- get computer id from the user
    print("What computer would you like to send a command to?")
    write("> ")
    local id = read()
    -- get a command from the user
    print("What command would you like to run?")
    write("> ")
    local command = read()
  
    -- send the command
    rednet.send(tonumber(id), command)
    term.setTextColor(512)
    print("\nSent.\n")
    term.setTextColor(1)
    
    -- check if command is recieved.
    local _, confirmation = rednet.receive(nil, 5)
    if confirmation ~= nil then
      term.setTextColor(8192)
      print(confirmation .. "\n")
      term.setTextColor(1)
    end

    -- check if any error command is recieved
    local _, error = rednet.receive(nil, 5)
    if error ~= nil then
      term.setTextColor(16384)
      print(error .. "\n")
      term.setTextColor(1)
    end

    -- check if mining is done.
    local _, eventFinished = rednet.receive(nil, 900)
    print("Waiting for program to send execution complete message...")
    if error ~= nil then
      term.setTextColor(2048)
      print(eventFinished .. "\n")
      term.setTextColor(1)
    end

  end