--Handed out by base_merchant
--To enable crafting orders, add the CraftOrderSkill objVar to a merchant template, and assign to the skill according to AllRecipes
--/create crafting_order picks a random crafting order from CraftingOrderDefines, regardless of skill


AddUseCase(this,"Add item to order",true,"UseObject")
AddUseCase(this, "Read order", true, "UseObject")
SetDefaultInteraction(this,"Add item to order")

function InitCraftingOrder()
	if (this:GetObjVar("OrderInfo") == nil) then 
		this:SetObjVar("OrderInfo", CraftingOrderDefines.FabricationSkill.CraftingOrders[6])
	end

	local orderInfo = this:GetObjVar("OrderInfo")
	local recipe = GetRecipeFromEntryName(orderInfo.Recipe)
	this:SetObjVar("OrderRecipe", recipe)
	this:SetObjVar("OrderAmount", orderInfo.Amount)
	this:SetObjVar("CurrentAmount", 0)

	local tooltip = "[ffffff]"..this:GetObjVar("CurrentAmount").."/"..this:GetObjVar("OrderAmount")
	SetTooltipEntry(this,"amount",tooltip)

	this:SetName("Craft Order: "..this:GetObjVar("OrderAmount").." "..GetItemNameFromOrderInfo())
end

function GetRecipeTemplateObjectName(recipeTable,material)
	if (recipeTable == nil) then
		LuaDebugCallStack("ERROR: recipeTable is nil") 
	end
	local materialName = ""
	if ( material and Materials[material] and ResourceData.ResourceInfo[material].CraftedItemPrefix ~= nil ) then
		materialName = ResourceData.ResourceInfo[material].CraftedItemPrefix .. " "
	end
	return materialName .. ( GetTemplateObjectName(recipeTable.CraftingTemplateFile) )
end

function GetItemNameFromOrderInfo()
	if (this:GetObjVar("OrderInfo") ~= nil) then
		return GetRecipeTemplateObjectName(this:GetObjVar("OrderRecipe"), this:GetObjVar("OrderInfo").Material)
	else 
		return this:GetObjVar("OrderRecipe").DisplayName
	end
end


--Check if item is a stack. If so, compare GetItemNameFromOrderInfo and singular name
function HandleSelectedTaskItem(target, user)
	
	if (target == nil) then return end	
	--if (target:GetObjVar("CraftedBy") ~= user:GetName() or GetItemNameFromOrderInfo()  ~= target:GetName()) then return end
	

	if not (VerifyTarget(target, user)) then return end


	AddToOrder(target, user)
	local currentAmount = this:GetObjVar("CurrentAmount")
	if (currentAmount >= this:GetObjVar("OrderAmount")) then 
		if not (this:GetObjVar("OrderComplete")) then 
			CompleteOrder(user)
		else
			user:SystemMessage("This order is already complete. Turn it in to a craftsman for your reward!","info")
			return
		end
	end

	user:RequestClientTargetGameObj(this, "select_task_item")
	local tooltip = "[ffffff]"..this:GetObjVar("CurrentAmount").."/"..this:GetObjVar("OrderAmount")
	SetTooltipEntry(this,"amount",tooltip)
end

function VerifyTarget(target, user)

	local orderInfo = this:GetObjVar("OrderInfo")
	local orderRecipe = this:GetObjVar("OrderRecipe")
	local crafter = target:GetObjVar("Crafter")

	if (target:TopmostContainer() ~= user) then
		user:SystemMessage("Item must be in your backpack.","info")
		user:RequestClientTargetGameObj(this, "select_task_item")
		return false
	end	
	
	if (orderInfo == nil) then return end

	if (crafter ~= user) then
		user:SystemMessage("This item was not created by you.","info")
		user:RequestClientTargetGameObj(this, "select_task_item")
	 	return false
	end
	
	local targetMaterial = target:GetObjVar("Material")
	local targetTemplate = target:GetCreationTemplateId()

	--If object is packed, get the unpacked template
	local weight = GetTemplateObjectProperty(orderRecipe.CraftingTemplateFile,"Weight")
	if (weight == -1) then
		if (target:HasObjVar("UnpackedTemplate")) then 
			targetTemplate = target:GetObjVar("UnpackedTemplate")
		else
			return false
		end
	end

	if ((targetTemplate ~= orderRecipe.CraftingTemplateFile or targetMaterial ~= orderInfo.Material)) then
		user:SystemMessage("That is not the correct item for this order.","info")
		user:RequestClientTargetGameObj(this, "select_task_item")
		return false
	end

	if (user ~= this:GetObjVar("OrderOwner")) then
		user:SystemMessage("This crafting order was not issued to you.","info")
		user:RequestClientTargetGameObj(this, "select_task_item")
	 	return false
	end

	return true
end

function AddToOrder(target, user)
	local stackCount = target:GetObjVar("StackCount")
	local currentAmount = this:GetObjVar("CurrentAmount")
	local amountToAdd = 0

	if (currentAmount == this:GetObjVar("OrderAmount")) then return end

	if (stackCount == nil) then
		amountToAdd = 1
	else
		amountToAdd = this:GetObjVar("OrderAmount") - currentAmount
		if (amountToAdd > stackCount) then
			amountToAdd = stackCount
		end
	end

	if (stackCount ~= nil) then
		user:SystemMessage("Added "..amountToAdd.." "..target:GetName().." to crafting order.","info")
		RequestConsumeResource(user,target:GetObjVar("ResourceType"), amountToAdd ,"ConsumeResourceResponse",this, target)
	else
		user:SystemMessage("Added "..target:GetName().." to crafting order.","info")
		target:Destroy()
	end

	this:SetObjVar("CurrentAmount", (currentAmount + amountToAdd))
end

function CompleteOrder(user)
	user:PlayObjectSound("event:/ui/skill_gain", false)
	user:SystemMessage("Crafting order complete. Turn in to craftsman for reward.", "info")
	RemoveUseCase(this, "Add item to order")
	SetDefaultInteraction(this, "Read order")
	this:SetObjVar("OrderComplete", true)
end

RegisterEventHandler(EventType.Message,"UseObject",function (user,useType)
    if (not useType == "Add item to order" or not useType == "Read order") then return end

    	if (useType == "Add item to order") then

    		if (this:TopmostContainer() ~= user) then
				user:SystemMessage("Crafting order must be in your backpack.","info")
				return
			end

    		user:RequestClientTargetGameObj(this, "select_task_item")
    	end

    	if (useType == "Read order") then
    		local orderOwner = this:GetObjVar("OrderOwner")
    		if (orderOwner ~= nil) then
    			user:SystemMessage("The order was issued to "..orderOwner:GetName().. " and calls for "..this:GetObjVar("OrderAmount").." "..GetItemNameFromOrderInfo(),"info")
    		else
    			user:SystemMessage("This order calls for "..this:GetObjVar("OrderAmount").." "..GetItemNameFromOrderInfo(),"info")
    		end
    	end
end)

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
    function (success,transactionId,user, target)
    	if (success) then
    	end
    end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "select_task_item", HandleSelectedTaskItem)

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), function()
	InitCraftingOrder()
	end)