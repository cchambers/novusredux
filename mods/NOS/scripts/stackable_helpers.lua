
function GetSingularName(obj)
	if obj == nil then obj = this end
	return obj:GetObjVar("SingularName")
end

function GetPluralName(obj)
	if obj == nil then obj = this end

	local pluralName = obj:GetObjVar("PluralName")
	-- no plural name fall back to singular
	if not( pluralName ) then
		pluralName = GetSingularName(obj)
	end

	return pluralName
end

function GetStackNameColor(obj)
	if obj == nil then obj = this end
	local curStackName, color = StripColorFromString(obj:GetName())

	return color
end

function UpdateStackName(newCount, obj)
	if obj == nil then obj = this end
	--DebugMessage("UpdateStackName",tostring(obj:GetCreationTemplateId()),tostring(newCount))
	if( not(obj:HasObjVar("SingularName"))) then
		local singularName = StripColorFromString(obj:GetName())
		obj:SetObjVar("SingularName",singularName)
	end

	-- bail if count is invalid
	if( newCount <= 0 ) then 
		return
	end

	local newName = nil

	-- money is a special case
	if( obj:GetObjVar("ResourceType") == "coins") then
		obj:SetName("[FF0000]Coin Purse ("..newCount.."c)[-]")
		UpdateSplitStack(obj)
		return
	end
	
	-- just one so use singular name
	if( newCount == 1 ) then
		newName = GetSingularName(obj)
	-- otherwise just combine count and the plural name
	else
		newName = tostring(newCount) .. " " .. GetPluralName(obj)
	end

	-- add our color back in
	local color = GetStackNameColor(obj)
	if( color ~= nil ) then
		newName = color .. newName .. "[-]"
	end

	--DebugMessage("Setting name to "..newName)
	obj:SetName(newName)

	UpdateSplitStack(obj)

end

function UpdateSplitStack(obj)
	if obj == nil then obj = this end
	-- prevent players from splitting stacks on merchant items
	if obj:HasObjVar("merchantOwner") then return end
	local stackCount = obj:GetObjVar("StackCount") or 1
	if (stackCount > 1 and not HasUseCase(obj,"Split Stack")) then
        AddUseCase(obj,"Split Stack",false)
	elseif (HasUseCase(obj,"Split Stack") and stackCount == 1) then
        RemoveUseCase(obj,"Split Stack")
	end
end

function OpenSplitWindow(user,fieldAmount)
	local title = "Split Stack"

	if this:HasObjVar("merchantOwner") then
		title = "Purchase "..GetPluralName()
	end

	local newWindow = DynamicWindow("StackSplit",title,238,96,-50,-50,"","Center")
	newWindow:AddButton(20,15,"MinusOneStack","",0,0,"","",false,"Previous")
	newWindow:AddTextField(37,10,56,20,"StackAmount",fieldAmount or "1")
	newWindow:AddButton(100,15,"PlusOneStack","",0,0,"","",false,"Next")
	newWindow:AddButton(120,5,"CreateStack","Accept",0,0,"","",true)
    user:OpenDynamicWindow(newWindow,this)
end

function MerchantUpdateStackCount(obj, newCount)
	obj:SetObjVar("StackCount", newCount)
	UpdateStackName(newCount, obj)
end