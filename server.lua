
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



local cenaLeczenia = 1000

ESX.RegisterServerCallback('esx_baska:kupLeczenie', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source

	if xPlayer.getMoney() >= cenaLeczenia then
		xPlayer.removeMoney(cenaLeczenia)
		TriggerClientEvent('esx:showNotification', source, 'Zapłaciłeś za leczenie ~g~$'..cenaLeczenia)

		dodiscordwyslij(16711680, 'LOGI BASKA', '```ID [' .. source .. '] | ' .. GetPlayerName(source) .. '```**\nZakupił leczenie u bachy i zapłacił '..cenaLeczenia..'$**', "FancyLand")


		cb(true)
	else
		cb(false)
	end
end)

  function dodiscordwyslij(color, name, message, footer)
	local embed = {
		  {
			  ["color"] = color,
			  ["title"] = "**".. name .."**",
			  ["description"] = message,
			  ["footer"] = {
				  ["text"] = footer,
			  },
		  }
	  }
  
	PerformHttpRequest('WEEBHOOK', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
  end


  --SKRYPT NIE JEST W 100% MOJ ZOSTAŁY DODANE TROCHE FUNKCJE + LOGI