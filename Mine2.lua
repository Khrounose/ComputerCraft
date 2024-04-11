-- Minimum fuel required in turtle.
local minimumFuel = 320

-- Distance you want it to mine out to.
local distance = 100

-- Is rednet open?
local isRednetOpen = rednet.isOpen()

-- Refuels the turtle for 320 blocks.
local function refuel()
    -- Check each slot for coal.
    for slot = 1, 16 do
        turtle.select(slot)
        local checkB = turtle.getFuelLevel()
        turtle.refuel(4)
        local checkA = turtle.getFuelLevel()
        -- Check before and after to see if refueled. 
        if checkB ~= checkA then
            -- If fuel has reached correct amount.
            if checkA >= minimumFuel then
                print("Refueled.")
                turtle.select(1)
                break
            -- If not enough fuel.
            else
                turtle.select(1)
                error("Minimum fuel not met. \nExiting program.", 0)
            end
        else
            print("No fuel in slot " .. slot .. " checking slot " .. slot + 1)
        end
        -- If loop ends and finds no fuel then
        if slot == 16 then
            turtle.select(1)
            error("No Fuel found, please feed me.", 0)
        end
    end 
end

--Checks if turtle meets required fuel
local function fuel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel < minimumFuel then
        refuel()
    else
        print("Turtle has minimum fuel required.")
    end
end

-- Checks for diamond every time it moves
local function dfs()
    -- search front, left, back, right
    for i = 1, 4 do
      local _, inspect = turtle.inspect()
      if inspect.name == "minecraft:diamond_ore" or inspect.name == "minecraft:deepslate_diamond_ore" then
        print("Detected Diamond")
        turtle.dig()
        turtle.forward()
        dfs() -- this does the same search procedure in the next block
        turtle.back()
      end
      turtle.turnLeft()
    end
    -- search up
    local _, inspect = turtle.inspectUp()
    if inspect.name == "minecraft:diamond_ore" or inspect.name == "minecraft:deepslate_diamond_ore" then
      turtle.digUp()
      turtle.up()
      dfs() -- this does the same search procedure in the next block
      turtle.down()
    end
    -- search down
    local _, inspect = turtle.inspectDown()
    if inspect.name == "minecraft:diamond_ore" or inspect.name == "minecraft:deepslate_diamond_ore" then
      turtle.digDown()
      turtle.down()
      dfs() -- this does the same search procedure in the next block
      turtle.up()
    end
  end

  -- Makes uturn back to entrance
local function uTurn()
    print("Making u-turn.")
    turtle.turnLeft()
    turtle.dig()
    turtle.forward()
    dfs()
    turtle.dig()
    turtle.forward()
    dfs()
    turtle.dig()
    turtle.forward()
    dfs()
    turtle.turnLeft()

end

-- Checks for gravel and mines it without interfering with counter.
local function gravelDetector()
    local _, inspect = turtle.inspect()
    if inspect.name == "minecraft:gravel" or inspect.name == "minecraft:sand" then
        turtle.dig()
        gravelDetector()
        print("Encountered Gravel.")
    end
end

-- Checks if rednet is open, if so then send message of status.
local function broadcastStatus(status)
    if isRednetOpen == true then
        turtle.select(1)
        turtle.equipRight()
        peripheral.find("modem", rednet.open)
        rednet.broadcast(status)
        turtle.equipRight()
    end
end

-- Checks how many diamonds


-- Cycles through the inventory and checks if each slot has an item in it.
local function inventoryChecker()
    for slot = 1, 16 do
        turtle.select(slot)
        local slotHasItem = turtle.getItemDetail(slot, false)
        if slotHasItem == nil then
            turtle.select(1)
            return
        end
        if slotHasItem.name == "minecraft:diamond" then
            print("There are: " .. turtle.getItemCount() .. " diamond(s) stored.")
            broadcastStatus("There are: " .. turtle.getItemCount() .. " diamond(s) stored.")
        end
    end
    turtle.select(1)
    broadcastStatus("Inventory is full!")
    error("Inventory is Full!", 0)
end

-- Checks fuel, checks inventory, then mines in a straight line for x blocks while looking for diamonds
local function mine()
    print("Beginning to mine.")
    for i = 1, distance do
        if turtle.forward() == true then
            dfs()
        else
            turtle.dig()
            gravelDetector()
            turtle.forward()
            dfs()
        end
    print(i)
    end
end

fuel()
inventoryChecker()
mine()
uTurn()
mine()
turtle.turnRight()
turtle.forward()
turtle.forward()
turtle.forward()
turtle.turnRight()
print("Finished mining.")
broadcastStatus("Finished mining.")