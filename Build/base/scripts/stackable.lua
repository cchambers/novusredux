require "stackable_helpers"
-- objvar "ResourceType" determines if two objects can be stacked together
-- we need to use these messages to make sure that coins are never removed more than once

-- this member is the definitive value.  we store it as an objvar so it is persisted in the backup
function CanSplit(user)
	if(user:CarriedObject()) then
		user:SystemMessage("Already carrying something.", "info")
		return false
	end
	local topmost = this:TopmostContainer() or this

	local bankObj = user:GetEquippedObject("Bank")

	local inBank = FindItemInContainerRecursive(bankObj,function(item)
			return item == this
		end)

	if (IsInBank(this)) then
		local bankSource = user:GetObjVar("BankSource")
		if (bankSource ~= nil and bankSource:DistanceFromSquared(user) > (OBJECT_INTERACTION_RANGE * OBJECT_INTERACTION_RANGE)) then
			user:SystemMessage("Too far away","info")
			return false
		end
	end

	local container = this:ContainedBy()
	if (container ~= nil) then
		local containerLocked = false
		ForEachParentContainerRecursive(this,false,
			function (parentObj)
				if( parentObj:HasObjVar("locked") ) then
				    local key = GetKey(user,parentObj)
				    if (key) then
				    	if (key:GetObjVar("IsHouseKey") ~= true and parentObj:GetObjVar("LockedDown") ~= true) then          
							containerLocked = true
							return false
						end
					else
						containerLocked = true
						return false
					end
				end
			return true
		end)

		if (containerLocked == true) then
			user:SystemMessage("That appears to be in a locked container.","info")
			return
		end
	end

	if (topmost ~= user) then
		if ( topmost:IsMobile() ) then
			user:SystemMessage("Cannot split that here.", "info")
			return false
		end
		
		--DebugMessage("range is "..tostring(topmost:DistanceFrom(user)))
		if (topmost:DistanceFromSquared(user) > (OBJECT_INTERACTION_RANGE * OBJECT_INTERACTION_RANGE)) then
			user:SystemMessage("Too far away.", "info")
			return false
		end

		local container = this:TopmostContainer()
		if (container ~= nil and not(user:HasLineOfSightToObj(container,ServerSettings.Combat.LOSEyeLevel))) then
			user:SystemMessage("Cannot see that.","info")
			return false
		end

		if (topmost:HasObjVar("IsMailbox") and topmost:GetObjVar("LockedDown")) then
		--if I'm not the owner
			--DebugMessage(2)
			if (not IsHouseOwnerForLoc(user,topmost:GetLoc())) then
				--DebugMessage(3)
				user:SystemMessage("Cannot pick that up.", "info")
				return false
			end
		end 
	end
	return true
end


function SetStack(amount)
	local singleWeight = this:GetObjVar("UnitWeight") or 1
	
	local curWeight = this:GetSharedObjectProperty("Weight")
	local newWeight = math.max(1, amount*singleWeight)
	local adjustWeightBy = newWeight - curWeight

	this:SetObjVar("StackCount", amount)
	UpdateStackName(amount, this)
	if(adjustWeightBy ~= 0) then
		this:SetSharedObjectProperty("Weight", newWeight)

		local containedObj = this:ContainedBy()
		if(containedObj ~= nil) then
			containedObj:SendMessage("AdjustWeight", adjustWeightBy)
		end
	end
end

function AdjustStack(delta)
	local stackCount = this:GetObjVar("StackCount") or 1
	local singleWeight = this:GetObjVar("UnitWeight") or 1
	stackCount = stackCount + delta
	if( stackCount <= 0 ) then
		this:Destroy()
	else
		local curWeight = this:GetSharedObjectProperty("Weight")
		local totalWeight = math.max(1, stackCount*singleWeight)
		local adjustWeightBy = totalWeight - curWeight

		this:SetObjVar("StackCount", stackCount)
		UpdateStackName(stackCount)

		if(adjustWeightBy ~= 0) then
			this:SetSharedObjectProperty("Weight", totalWeight)
			--DebugMessage("Adjusting Stack Weight By  "..adjustWeightBy.." - Old: "..curWeight.." New: "..totalWeight)

			local containedObj = this:ContainedBy()
			if(containedObj ~= nil) then
				--DebugMessage("(2) adjustWeightBy is "..tostring(adjustWeightBy))
				containedObj:SendMessage("AdjustWeight", adjustWeightBy)
			end
		end
	end
end

function HandleLoaded()
	local stackCount = this:GetObjVar("StackCount") or 1
	if(GetWeight(this) ~= -1) then
		local singleWeight = this:GetObjVar("UnitWeight") or 1
		local stackWeight = math.ceil(math.max(1,stackCount*singleWeight))
		if(this:GetSharedObjectProperty("Weight") ~= stackWeight) then
			this:SetSharedObjectProperty("Weight",stackWeight)
		end
	end
	UpdateStackName(stackCount)
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
	function()
		HandleLoaded()
	end)

RegisterSingleEventHandler(EventType.LoadedFromBackup, "", 
	function()
		-- enable this to fix stackable weight from templates
		--local unitWeight = this:GetObjVar("UnitWeight") or 1
		--local templateWeight = GetTemplateObjVar(this:GetCreationTemplateId(),"UnitWeight") or 1
		--if(unitWeight ~= templateWeight) then
		--	this:SetObjVar("UnitWeight",templateWeight)
		--end

		HandleLoaded()
	end)

RegisterEventHandler(EventType.Message, "SetStackCount", 
	function(amount)
		if( amount ~= nil ) then
			SetStack(amount)
		end	
	end)

RegisterEventHandler(EventType.Message, "AdjustStack", 
	function(amount)
		if( amount ~= nil ) then
			AdjustStack(amount)
		end	
	end)

local pendingStack = false

RegisterEventHandler(EventType.Message, "StackOnto", 
	function(otherObj)
		if( not(pendingStack) and otherObj:IsValid() and otherObj ~= this ) then		
			--DebugMessage("OtherObj.ID is "..tostring(otherObj.Id).. " and it's name is "..tostring(otherObj:GetName()))			
			local amount = GetStackCount(otherObj)
			AdjustStack(amount)
			otherObj:Destroy("StackOnto",amount)		
			pendingStack = true	
		end
	end)

RegisterEventHandler(EventType.DestroyedObject, "StackOnto",
	function (success,amount)
		if not(success) then
			AdjustStack(-amount)
		end
		this:PlayObjectSound("Drop",true)
		pendingStack = false
	end)

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Split Stack") then return end
        if(IsLockedDown(this)) then
        	--user:SystemMessage("That object is locked down and can not be split.")
        	return
        end
        if(user:CarriedObject()) then
			user:SystemMessage("Already carrying something.", "info")
			return
		end
		if ( this:HasObjVar("itemOwner") ) then
			--user:SystemMessage("You must purchase that before you can split it.")
			return
		end
		-- TODO Can you split merchant for sale items?? Don't see a prevent here, need to test.
		--[[TODO: KARMA REPLACE
		if ( user:IsPlayer() and Should_WarnNotorietyLoot(this, user) ) then
			Warn_Notoriety(this, user) KARMA REPLACE
			return
		end]]
		
		--TODO: KARMA REPLACE
		--CheckNotorietyLoot(this,user)
        OpenSplitWindow(user,"1")
    end)

RegisterEventHandler(EventType.Message,"StackSplit",
	function (amount,destContainer,destLocation)
		local stackCount = this:GetObjVar("StackCount") or 1
		newAmount = tonumber(amount)
		if (newAmount < 1) then
			newAmount = 1
		elseif newAmount > stackCount then
			newAmount = stackCount
		end
			-- to put something in a players carry slot you create the object in their body
		CreateObjInContainer(this:GetCreationTemplateId(), destContainer, GetRandomDropPosition(destContainer), "stack_created",{Amount = newAmount})
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"StackSplit",
	function (user,buttonId,fieldData)
		local stackCount = this:GetObjVar("StackCount") or 1
		newAmount = math.floor(tonumber(fieldData.StackAmount))
		if not(newAmount) then
			return
		end
		
		if (tonumber(fieldData.StackAmount)-newAmount ~= 0) then
			user:SystemMessage("[$2631]")
			return
		end
		if (newAmount == nil or newAmount < 1) then
			newAmount = 1
		elseif newAmount > stackCount then
			newAmount = stackCount
		end
		if (buttonId == "CreateStack") then

			--handle buying stacks from merchants if the item has a merchantOwner
			local merchant = this:GetObjVar("merchantOwner")
			if(merchant ~= nil and merchant:IsValid()) then
				merchant:SendMessage("SellItem", user, this, newAmount)
				return
			end
			if (not CanSplit(user)) then
				return 
			end
			-- to put something in a players carry slot you create the object in their body
			CreateObjInContainer(this:GetCreationTemplateId(), user, Loc(0,0,0), "stack_created",{Amount = newAmount,User = user})
		end
		if (buttonId == "MinusOneStack") then
			OpenSplitWindow(user,tostring(math.max(1,newAmount - 1)))
		end
		if (buttonId == "PlusOneStack") then
			OpenSplitWindow(user,tostring(math.min(stackCount -1,newAmount + 1)))
		end
	end)

RegisterEventHandler(EventType.CreatedObject,"stack_created",
	function(success,objRef,args)
		if (not success) then
			DebugMessage("[stackable] ERROR: Stack not created for "..this:GetName() .. " by user "..args.User:GetName())
			this:SendMessage("AdjustStack",args.Amount)
			return
		end
		local vars = this:GetAllObjVars()
		for i,j in pairs(vars) do 
			if(i ~= "DecayTime") then
				objRef:SetObjVar(i,j)
			end
		end
		local scripts = this:GetAllModules()
		for i,j in pairs(scripts) do
			if(j ~= "decay" and not(objRef:HasModule(j))) then
				objRef:AddModule(j)
			end
		end
		local properties = this:GetAllSharedObjectProperties()
		for i,j in pairs(properties) do
			if (i ~= "Weight") then
				objRef:SetSharedObjectProperty(i,j)
			end
		end
		--DebugMessage("Amount is "..args.Amount)
		local stackCount = this:GetObjVar("StackCount")
		if (args.Amount < 1) then
			args.Amount = 1
		elseif args.Amount > stackCount then
			args.Amount = stackCount
		end
		--DebugMessage("stackCount is "..stackCount)
		RequestSetStackCount(objRef,args.Amount)
		AdjustStack(-args.Amount)
		args.User:SendMessage("PickupObject", objRef)
	end)