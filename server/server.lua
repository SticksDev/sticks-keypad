-- Add doors using the fomrat 
-- doors[doorId] = {loc_vector, teleport_vector, code}
print("[sticks_keypad] Loading doors...")

local doors = {
    -- Example door, feel free to remove this
    {1, {x = -3029.3825683594, y = 72.813552856445, z = 11.4}, {x = -3031.3232421875, y = 93.021644592285, z = 12.346099853516}, "1234"},
}

-- Print our loaded doors
for i, v in ipairs(doors) do
    print("[sticks_keypad] Loaded door id: " .. v[1] .. " with code: " .. v[4] .. " and teleport vector: " .. v[2].x .. ", " .. v[2].y .. ", " .. v[2].z)
end

print("[sticks_keypad] Loaded " .. #doors .. " doors! Setting up events...")

-- Event to send the doors configuration to the client
RegisterServerEvent("sticks_keypad:getDoors")
AddEventHandler("sticks_keypad:getDoors", function()
    print("[sticks_keypad::audit] Player requested doors")
    TriggerClientEvent("sticks_keypad:setClientDoors", source, doors)
end)

-- Event to check if the code is correct, returns true if it is, nil if it isn't
RegisterServerEvent("sticks_keypad:checkCodeAndTeleport")
AddEventHandler("sticks_keypad:checkCodeAndTeleport", function(doorId, code)
    print("[sticks_keypad::audit] Player is trying to open door id: " .. doorId .. " with code: " .. code)
    local source = source

    if doors[doorId][4] == code then
        print("[sticks_keypad::audit] Player opened door id: " .. doorId)
        -- Teleport the player to the teleport vector
        SetEntityCoords(source, doors[doorId][3].x, doors[doorId][3].y, doors[doorId][3].z)
        return true
    else
        print("[sticks_keypad::audit] Player failed to open door id: " .. doorId)
        return nil
    end
end)

print("[sticks_keypad] Events setup! Ready to go!")