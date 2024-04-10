-- Refuels the turtle
local function fuel()
    print("Checking Fuel...")
    -- Checking if fuel is less than 320, then refueling it.
    if turtle.getFuelLevel() < 320 then
        coalCount = turtle.getItemCount(1)
        turtle.select(1)
        turtle.refuel(4)
        coalCount2 = turtle.getItemCount(1)
        -- If no coal found in select(1)
        if coalCount == coalCount2 then
            print("Unable to refuel. Shutting down.")
            return false
        end
        print("Refueled")
        print("Fuel Remaining: " .. turtle.getFuelLevel())
        print("Coal Remaining: " .. turtle.getItemCount(1))
    -- If fuel > 320
    else
        print("Fuel Remaining: " .. turtle.getFuelLevel())
        print("Coal Remaining: " .. turtle.getItemCount(1))
    end
    return true
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

local function gravelDetector()
    local _, inspect = turtle.inspect()
    if inspect.name == "minecraft:gravel" or inspect.name == "minecraft:sand" then
        turtle.dig()
        gravelDetector()
        print("Encountered Gravel.")
    end
end

-- Mines in a straight line for x blocks
local function mine()
    if fuel() == true then
        local distance = 0
        while distance < 100 do
            if turtle.forward() == true then
                dfs()
                distance = distance + 1
            else
                gravelDetector()
                turtle.dig()
                turtle.forward()
                dfs()
                distance = distance + 1
            end
        print(distance)
        end
    else
        error("No Fuel", 0)
    end
end

mine()
uTurn()
mine()
turtle.turnRight()
turtle.forward()
turtle.forward()
turtle.forward()
turtle.turnRight()
print("Finished mining.")