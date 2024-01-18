local function GetItemFromShop(itemName, zone)
	local ShopItemsByZone = Config.Zones[zone].Items

	for i = 1, #ShopItemsByZone do 
		local itemData = ShopItemsByZone[i]
		if itemData.name == itemName then
			return true, itemData.price, itemData.label
		end
	end 

	return false
end

RegisterNetEvent('esx_shops:buyItem', function(itemName, amount, zone)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local Exists, price, label, amount = GetItemFromShop(itemName, zone), ESX.Math.Round(amount)

	if amount < 0 or not Exists then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to exploit the shop!'):format(source))
		return
	end

	if Exists then
		price = price * amount
		local money = xPlayer.getMoney()
		if money >= price then
			if xPlayer.canCarryItem(itemName, amount) then
				xPlayer.removeMoney(price, label .. " " .. TranslateCap('purchase'))
				xPlayer.addInventoryItem(itemName, amount)
				xPlayer.showNotification(TranslateCap('bought', amount, label, ESX.Math.GroupDigits(price)))
			else
				xPlayer.showNotification(TranslateCap('player_cannot_hold'))
			end
		else
			local missingMoney = price - money
			xPlayer.showNotification(TranslateCap('not_enough', ESX.Math.GroupDigits(missingMoney)))
		end
	end
end)
