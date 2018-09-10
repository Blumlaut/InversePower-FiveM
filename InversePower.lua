speed = 0.0;
rel_vector = { 0.0, 0, 0.0, 0, 0.0, 0 };
angle = 0.0;

base = 35.0;
power_adj = 1.0;
torque_adj = 1.0;
angle_impact = 3.0;
speed_impact = 2.0;

speed_mult = 0.0;
power_mult = 1.0;
torque_mult = 1.0;

accelval = 127;
brakeval = 127;

disablep = 0;
disablet = 0;


power_adj = 100.0
torque_adj = 80.0
angle_impact = 350.0
speed_impact = 200.0
base = 35.0
deadzone = 25.0


levels = {
	[0] = { name="Default", deadzone = 25.0 },
	[1] = { name="Sensitive", deadzone = 15.0},
	[2] = { name="Drift", deadzone = 10.0},
	[3] = { name="Disabled", deadzone = 180.0},
}
curLevel = 0
maxLevel = #levels+1 -- one level aboth the last level
control = 166
enableKey = true

RegisterNetEvent("InversePower:SetLevel")


AddEventHandler("InversePower:SetLevel", function(level)
	curLevel = level
	deadzone = levels[level].deadzone
	name = levels[level].name
	DisplayHelpText("InversePower: "..levels[level].name)
end)



Citizen.CreateThread( function()
	Wait(10)
	RegisterNetEvent("InversePower:plsgibconfig")
	AddEventHandler("InversePower:plsgibconfig", function(config)
		curLevel = config.defaultLevel
		deadzone = levels[curLevel].deadzone
		name = levels[curLevel].name
		drawDebug = config.drawDebug
		enableKey = config.enableKey
		control = config.toggleKey
		power_adj = config.power_adj+.0
		torque_adj = config.torque_adj+.0
		angle_impact = config.angle_impact+.0
		speed_impact = config.speed_impact+.0
	end)
	TriggerServerEvent("InversePower:plsgibconfig")
	
	while true do
		ped = PlayerPedId()
		veh = GetVehiclePedIsUsing( ped )
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and DoesEntityExist(veh) and GetPedInVehicleSeat(veh, -1) == ped then
			if IsControlJustReleased(0, control) and enableKey then
				curLevel = curLevel+1
				if curLevel == maxLevel then
					curLevel = 0
				end
				deadzone = levels[curLevel].deadzone
				name = levels[curLevel].name
				DisplayHelpText("InversePower: "..name)
			end
		end
		Citizen.Wait( 0 )
	end
end )

Citizen.CreateThread(function()
	while true do
		player = PlayerId()
		playerPed = PlayerPedId()
		valid = true -- stupid workaround because my brain broke
		
		if not DoesEntityExist(playerPed) or not IsPlayerControlOn(PlayerPed) then
			valid = false
		end
		
		if IsEntityDead(playerPed) then
			valid = false
		end
		
		if not GetVehiclePedIsUsing(playerPed) then
			valid = false
		end
		
		vehicle = GetVehiclePedIsUsing(playerPed)
		if not IsThisModelACar( GetEntityModel(vehicle)) then
			valid = false
		end
		Wait(100)
	end

end)

Citizen.CreateThread(function()
	
	function DisplayHelpText(str)
		SetTextComponentFormat("STRING")
		AddTextComponentString(str)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	end
	
	function DrawHudText(text,colour,coordsx,coordsy,scalex,scaley)
		SetTextFont(4)
		SetTextProportional(4)
		SetTextScale(scalex, scaley)
		local colourr,colourg,colourb,coloura = table.unpack(colour)
		SetTextColour(colourr,colourg,colourb, coloura)
		SetTextDropshadow(0, 0, 0, 0, coloura)
		SetTextEdge(1, 0, 0, 0, coloura)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		EndTextCommandDisplayText(coordsx,coordsy)
	end
	
	while true do
		Citizen.Wait(1)
		
		if valid then
			
			if (base < 0.0) then
				base = 35.0
			end
			
			speed = GetEntitySpeed(vehicle)
			rel_vector = GetEntitySpeedVector(vehicle, true)
			
			angle = math.acos(rel_vector.y / speed)*180 / 3.14159265;
			
			if type(angle) ~= "number" or angle ~= angle then
				angle = 0.0
			end
			
			if speed < base then
				speed_mult = (base - speed) / base
			end
			
			power_mult = 1.0 + power_adj * (((angle / 90) * angle_impact) + ((angle / 90) * speed_mult * speed_impact));
			torque_mult = 1.0 + torque_adj * (((angle / 90) * angle_impact) + ((angle / 90) * speed_mult * speed_impact));
			power_mult = power_mult / 1500
			torque_mult = torque_mult / 1500
			
			
			accelval = GetControlValue(0, 71)
			brakeval = GetControlValue(0, 72)
			if drawDebug then
				DrawHudText("ANGL:"..angle.."\nDDZON:"..deadzone.."\nACCLVAL:"..accelval.."\nBRKVAL="..brakeval.."\nPWRM:"..power_mult.."\nTRQM:"..torque_mult, table.pack(255,255,255,255), 0.5,0.0,0.5,0.5)
			end
			if angle < 80 and angle > deadzone and brakeval < accelval+ 12 then
				if disablet == 0 then
					SetVehicleEngineTorqueMultiplier(vehicle, torque_mult)
				end
				if disablep == 0 then
					SetVehicleEnginePowerMultiplier(vehicle, power_mult)
				end
			else
				power_mult = 1.0;
				torque_mult = 1.0;
				SetVehicleEnginePowerMultiplier(vehicle, power_mult)
				SetVehicleEngineTorqueMultiplier(vehicle, torque_mult)
			end
		end
	end
end)