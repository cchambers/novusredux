

AI.NotEnoughStockMessages = {
	"I don't have that many available."
}

AI.OutOfStockMessages = {
	"I'm sorry, but that item is out of stock."
}

function Merchant.DoNotEnoughStock(buyer)
	QuickDialogMessage(this,buyer, AI.NotEnoughStockMessages[math.random(1, #AI.NotEnoughStockMessages)],-1)
end

function Merchant.DoOutOfStock(buyer)
	QuickDialogMessage(this,buyer, AI.OutOfStockMessages[math.random(1, #AI.OutOfStockMessages)],-1)
end

function Merchant.CountStock(item)
	if (item == nil) then return 0 end
	if not(item:IsValid()) then return 0 end
	if (item:HasObjVar("OutOfStock")) then return 0 end

	if IsStackable(item) then
		return GetStackCount(item)		
	else
		return item:GetObjVar("NumAvailable") or 1		
	end
end

function Merchant.SetOutOfStock(item)
	item:SetObjVar("OutOfStock",true)
	item:SetColor("66FFFFFF")
	SetTooltipEntry(item,"item_price","Out of Stock",100)
end

-- used only after a purchase, will update merchants current stock
function Merchant.UpdateStock(merchant, item, amount)
	local unlimitedStock = item:GetObjVar("UnlimitedStock")
	-- DAB HACK: UNLIMITED STOCK HACK
	--local unlimitedStock = true
	if IsStackable(item) then
		local stackCount = item:GetObjVar("StackCount")
		if( amount > stackCount ) then
			return false
		end
		if ( unlimitedStock ~= true ) then
			if( amount == stackCount ) then
				-- bought them all, will re-stock later.
				RequestSetStackCount(item,1)
				Merchant.SetOutOfStock(item)
			else
				-- update the stack count for stocked item
				MerchantUpdateStackCount(item, stackCount - amount)
			end
		end
		return true
	else
		local numAvailable = item:GetObjVar("NumAvailable") or 1
		if ( unlimitedStock ~= true and numAvailable <= 1 ) then
			-- special case for selling pets
			if(item:IsMobile()) then
				item:Destroy()
			else
				item:DelObjVar("NumAvailable")
				Merchant.SetOutOfStock(item)			
			end
		else
			item:SetObjVar("NumAvailable",numAvailable-1)
		end
		return true
	end
	return false
end