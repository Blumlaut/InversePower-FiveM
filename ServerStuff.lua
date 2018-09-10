local defaultLevel = 0
local drawDebug = false
local enableKey = true
local toggleKey = 166
local power_adj = 100.0
local torque_adj = 80.0
local angle_impact = 350.0
local speed_impact = 200.0


function GetConvars()
	defaultLevel = GetConvarInt("InversePower_DefaultLevel", 0)
	
	if GetConvarInt("InversePower_toggleKey", 166) == 0 then
		enableKey = false
		toggleKey = 0
	else
		toggleKey = GetConvarInt("InversePower_toggleKey", 166)
	end

	if GetConvar("InversePower_DrawDebug", "false") == "true" then
		drawDebug = true
	else
		drawDebug = false
	end
	power_adj = GetConvarInt("InversePower_Power", 100)	
	torque_adj = GetConvarInt("InversePower_Torque", 80)	
	angle_impact = GetConvarInt("InversePower_Angle", 350)
	speed_impact = GetConvarInt("InversePower_Speed", 200)
	
end
	
	

Citizen.CreateThread(function()
	RegisterServerEvent("InversePower:plsgibconfig")
	AddEventHandler("InversePower:plsgibconfig", function()
		GetConvars()
		local config = {defaultLevel=defaultLevel,drawDebug=drawDebug,enableKey=enableKey,toggleKey=toggleKey,power_adj=power_adj,torque_adj=torque_adj,angle_impact=angle_impact,speed_impact=speed_impact}
		TriggerClientEvent("InversePower:plsgibconfig", source, config)
	end)
end)