
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1000)
    end
end)


bachaa              = {}

bachaa.Zones = {
		Doctor =	{
		pozycjapeda = {{x = 1123.94, y = 2440.0, z = 52.43, name = 'ped', h = 319.78, sprite = 51,	color = 59},},  
		Lozko = {{x = 1123.94, y = 2440.0, z = 52.43, h = 56.82},},          
		Napis = {{x = 1123.94, y = 2440.0, z = 52.43, h = 249.41},}
	}
}

local IsDead				  = false
local cam = nil



Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_m_doctor_01"))
    while not HasModelLoaded(GetHashKey("s_m_m_doctor_01")) do
      Wait(1)
	  
    end

	for k,v in pairs(bachaa.Zones) do
		for i = 1, #v.pozycjapeda, 1 do
			local hospitalped =  CreatePed(4, 0xd47303ac, v.pozycjapeda[i].x, v.pozycjapeda[i].y, v.pozycjapeda[i].z-0.1, v.pozycjapeda[i].h, false, true)
			SetEntityHeading(hospitalped, v.pozycjapeda[i].h)
			FreezeEntityPosition(hospitalped, true)
			SetEntityInvincible(hospitalped, true)

			SetBlockingOfNonTemporaryEvents(hospitalped, true)
		end
	end
	  
end)	

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		local plyCoords = GetEntityCoords(PlayerPedId(), 0)
		for k,v in pairs(bachaa.Zones) do
			for i = 1, #v.Napis, 1 do
		local distance = #(vector3(v.Napis[i].x, v.Napis[i].y, v.Napis[i].z) - plyCoords)
		if distance < 10 then
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
				if distance < 3 then
					ESX.Game.Utils.DrawText3D(vector3(v.Napis[i].x, v.Napis[i].y, v.Napis[i].z), 'NACIŚNIJ [~g~E~s~] ABY SIĘ ULECZYĆ KOSZT: 10000$', 0.4)
                    if IsControlJustReleased(0, 46) then
                        if (GetEntityHealth(PlayerPedId()) < 200) then
							TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, false)
							DisableAllControlActions(0)
								
							TriggerEvent("mythic_progbar:client:progress", {
								name = "unique_action_name",
								duration = 6000,
								label = "Sprawdzanie",
								useWhileDead = true,
								canCancel = true,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "amb@world_human_clipboard@male@idle_a",
									anim = "idle_c",
								},
								prop = {
									model = "p_amb_clipboard_01",
								}
							}, function(status)
								if not status then
								
								end
							end)

							Citizen.Wait(6000)

							EnableControlAction(1, 154)	
							ESX.TriggerServerCallback('esx_baska:kupLeczenie', function(bought)
								if bought then

									TriggerEvent('pNotify:SendNotification', {text = "Doktor sie tobą zajmuje, poczekaj chwile!", layout = "centerLeft"})

									--ESX.ShowNotification('Doktor sie tobą zajmuje, poczekaj chwile!')
									SetEntityCoords(GetPlayerPed(-1), v.Lozko[i].x, v.Lozko[i].y, v.Lozko[i].z, v.Lozko[i].h)
									FreezeEntityPosition(GetPlayerPed(-1), true)

									TriggerEvent("mythic_progbar:client:progress", {
										name = "unique_action_name",
										duration = 45000,
										label = "LECZENIE",
										useWhileDead = true,
										canCancel = true,
										controlDisables = {
											disableMovement = true,
											disableCarMovement = true,
											disableMouse = false,
											disableCombat = true,
										},
										animation = {
											animDict = "anim@gangops@morgue@table@",
											anim = "ko_front",
										},
										prop = {
											model = "",
										}
									}, function(status)
										if not status then
											TriggerEvent('pNotify:SendNotification', {text = "Twoje leczenie zakończyło się pozytywnie!", layout = "centerLeft"})

											--ESX.ShowNotification('Twoje leczenie zakończyło się ~g~pozytywnie~w~!')
											TriggerEvent('esx_ambulancejob:revive')
											FreezeEntityPosition(GetPlayerPed(-1), false)
											ClearPedTasks(GetPlayerPed(-1)) 
										end
									end)

								else
									--ESX.ShowNotification('Potrzebujesz ~r~10000$~w~ aby ukończyć leczenie!')
									TriggerEvent('pNotify:SendNotification', {text = "Potrzebujesz 10000$ aby ukończyć leczenie!", layout = "centerLeft"})

								end
							end)	


                        else
							TriggerEvent('pNotify:SendNotification', {text = "Nie potrzebujesz pomocy medycznej!", layout = "centerLeft"})

							--ESX.ShowNotification('~r~Nie potrzebujesz~w~ pomocy medycznej!')
							
                        end
                    end
                end
            end
		end
	end
end
    end
end)



-- For more informations join in my discord or send me private message (https://discord.gg/9MNf7Qgddr)/ (reyektm)


