--Basic buff layout, similar to map markers
--[[
{
	Identifier = "NameOfBuff"
	Icon = "SpriteImage",	
	Tooltip = "Tool tip describing the buff here."
	DisplayName = "Name of Buff"
	IsDebuff = true or false if it's a debuff
}
--]]
BUFF_COLOR = "[00D700]"
DEBUFF_COLOR = "[D70000]"
BUFFS_PER_ROW = 10
BUFF_SIZE = 24

mBuffs = {}

function HasBuffIcon(buffIdentifier)
	for i,j in pairs(mBuffs) do
		if (j.Identifier == buffIdentifier) then
		 	return true
		end
	end
	return false
end

function AddBuff(buff,timeSecs)
	if (buff == nil) then
		--LuaDebugCallStack("[base_player_buff_debuff] ERROR: Buff is nil!")
		return
	end
	--DebugMessage(1)
	if not( HasBuffIcon(buff.Identifier) ) then
		table.insert(mBuffs, buff)
	end
	if (timeSecs ~= nil) then
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(timeSecs),"RemoveBuffIcon|"..tostring(buff.Identifier),"RemoveBuffIcon|"..tostring(buff.Identifier))
		RegisterSingleEventHandler(EventType.Timer,"RemoveBuffIcon|"..tostring(buff.Identifier),
		function (actionId)
			local result = StringSplit(actionId,"|")
			local identifier = result[2]
			--DebugMessage(1.5)
			RemoveBuff(identifier)
			ShowBuffWindow()
		end)
	end
	ShowBuffWindow()
end

function RemoveBuff(buffIdentifier)
	for i,j in pairs(mBuffs) do
		if (j.Identifier == buffIdentifier) then
			mBuffs[i] = nil
			ShowBuffWindow()
			return
		end
	end
end

function ShowBuffWindow()
	local taskWindow = DynamicWindow("BuffBar","",0,0,0,0,"Transparent"--[["Transparent"--]],"Top")
	--for each buff we have
	--but wait if there's no buffs then just close the window
	if (#mBuffs == 0) then
		this:CloseDynamicWindow("BuffBar")
		return
	end
	--DebugMessage(DumpTable(buffs))	

	local BUFF_OFFSET = BUFF_SIZE + 2
	local numBuffs = #mBuffs
	local startX = -math.min(numBuffs,BUFFS_PER_ROW) * BUFF_OFFSET / 2
	
	for index,buff in pairs(mBuffs) do		
		--DebugMessage("Adding buff")
		--Get the display name
		local displayString = buff.DisplayName
		if (buff.IsDebuff) then
			displayString = DEBUFF_COLOR .. displayString .. "[-]\n"
		else
			displayString = BUFF_COLOR .. displayString .. "[-]\n"
		end
		--create a buff that shows something when you mouse over it
		displayString = displayString .. buff.Tooltip --.. " ".. tostring(index)

		local timeRemaining = this:GetTimerDelay("RemoveBuffIcon|"..tostring(buff.Identifier))
		if(timeRemaining) then
			displayString = displayString .. "\n\nRemaining: " .. GetTimerLabelString(timeRemaining,true)
		end
		
		taskWindow:AddButton(startX + (((index-1) % BUFFS_PER_ROW) * BUFF_OFFSET),math.floor((index-1)/BUFFS_PER_ROW)*BUFF_OFFSET,"","",BUFF_SIZE,BUFF_SIZE,displayString,"",false,"Invisible")
		taskWindow:AddImage(startX + (((index-1) % BUFFS_PER_ROW) * BUFF_OFFSET),math.floor((index-1)/BUFFS_PER_ROW)*BUFF_OFFSET,buff.Icon,BUFF_SIZE,BUFF_SIZE)
		--add the buff
	end
	--open the window
	this:OpenDynamicWindow(taskWindow)
end

--Show the buff window on login and create.
RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function ( ... )
	ShowBuffWindow()
end)
RegisterEventHandler(EventType.LoadedFromBackup,"",function ( ... )
	ShowBuffWindow()
end)

RegisterEventHandler(EventType.Message,"AddBuffIcon",function (buff,timeSecs)
	AddBuff(buff,timeSecs)
end)

RegisterEventHandler(EventType.Message,"RemoveBuffIcon",function (identifier)
	RemoveBuff(identifier)
	-- body
end)

--[[AddBuffIcon(this,"Wounded","Wounded","Deep Cuts","Max Health Reduced by " ..10 .. "\n Healing Reduced by 10%",true,30)
AddBuffIcon(this,"Wounded1","Wounded","Deep Cuts","Max Health Reduced by " ..20 .. "\n Healing Reduced by 10%",true,30)
AddBuffIcon(this,"Wounded2","Wounded","Deep Cuts","Max Health Reduced by " ..30 .. "\n Healing Reduced by 10%",true,30)
AddBuffIcon(this,"Wounded3","Wounded","Deep Cuts","Max Health Reduced by " ..40 .. "\n Healing Reduced by 10%",true,30)
AddBuffIcon(this,"Wounded4","Wounded","Deep Cuts","Max Health Reduced by " ..40 .. "\n Healing Reduced by 10%",true,30)
AddBuffIcon(this,"Wounded5","Wounded","Deep Cuts","Max Health Reduced by " ..40 .. "\n Healing Reduced by 10%",true,30)
AddBuffIcon(this,"Wounded6","Wounded","Deep Cuts","Max Health Reduced by " ..40 .. "\n Healing Reduced by 10%",true,30)
AddBuffIcon(this,"Wounded7","Wounded","Deep Cuts","Max Health Reduced by " ..40 .. "\n Healing Reduced by 10%",true,30)
AddBuffIcon(this,"Wounded8","Wounded","Deep Cuts","Max Health Reduced by " ..40 .. "\n Healing Reduced by 10%",true,30)]]