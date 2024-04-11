-- opening rednet
term.clear()
-- loop forever
while true do
  -- equip modem
  turtle.select(1)
  turtle.equipRight()
  peripheral.find("modem", rednet.open)
  -- wait for a rednet event
  print("Computer ID: " .. os.computerID())
  print("Listening...")
  local id, message = rednet.receive()
  print("Command from", id, ":", message)

  -- send back confirmation of received event
  rednet.send(id, "Command recieved. Executing: " .. message)

  -- equip back tool
  turtle.equipRight()
  -- run the command given
  shell.run(message)
end