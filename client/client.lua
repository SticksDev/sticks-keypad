local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
    
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextDropShadow(0, 0, 0, 55)
		SetTextEdge(0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

function dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end


-- When we start up, request the doors from the server
local clientDoors = {}
RegisterNetEvent('sticks_keypad:setClientDoors')
AddEventHandler('sticks_keypad:setClientDoors', function(doors)
  clientDoors = doors

  -- For each door, create a marker and a text label to allow the user to press "E" to open the keypad
  for i, v in ipairs(clientDoors) do
    -- Dump the door data
    print('[sticks_keypad] Loaded door id: ' .. v[1] .. ' with location vector: ' .. dump(v[2]))

     -- Create a draw thread
    Citizen.CreateThread(function()
      while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local doorCoords = vector3(v[2].x, v[2].y, v[2].z)
        local distance = #(playerCoords - doorCoords)

        if distance < 2.0 then
          DrawMarker(1, v[2].x, v[2].y, v[2].z + 0.5, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 0, 0, 200, 0, 0, 0, 0)
          Draw3DText(v[2].x, v[2].y, v[2].z + 0.5, "Press ~g~E~w~ to open the keypad")
          if IsControlJustPressed(0, 38) then
            toggleNuiFrame(true)
            SendReactMessage('sticks_keypad:uiInit', {doorId = v[1], code = v[4]})
          end
        end
      end
    end)
  end
end)

-- Handle the NUI message from the React app
RegisterNUICallback('sticks_keypad:codeSubmitSuccess', function(data, cb)
  toggleNuiFrame(false)
  dump(data)
  TriggerServerEvent('sticks_keypad:checkCodeAndTeleport', data.doorId, data.code)
  cb({ok = true})
end)

-- Hide Frame NUICallback
RegisterNUICallback('sticks_keypad:hideFrame', function(data, cb)
  toggleNuiFrame(false)
  cb({ok = true})
end)

-- Command to print out the current vector3 position of the player
RegisterCommand('getpos', function()
  local playerPed = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)
  print(playerCoords.x .. ', ' .. playerCoords.y .. ', ' .. playerCoords.z)
end, false)

-- Send the event to the server to get the doors
TriggerServerEvent('sticks_keypad:getDoors')