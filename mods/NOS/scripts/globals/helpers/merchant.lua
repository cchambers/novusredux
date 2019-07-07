

--- To prevent merchants from spawning multiples of the same item in the same spot on a restock,
--- we keep track of the items the merchant has stocked number of templates of that item currently available
-- @param merchant(mobileObj)
-- @return merchant's stock array(luaTable)
function GetMerchantStock(merchant)
    if ( merchant == nil ) then
        LuaDebugCallStack("Nil merchant provided to GetMerchantStock")
        return {}
    end
    return merchant:GetObjVar("Stock") or {}
end

--- Set the merchant's stock list.
-- @param merchant(mobileObj)
-- @param stock
-- @return none
function SetMerchantStock(merchant, stock)
    if ( merchant == nil ) then
        LuaDebugCallStack("Nil merchant provided to SetMerchantStock")
        return
    end
    if ( stock == nil ) then
        LuaDebugCallStack("Nil stock provided to SetMerchantStock")
        return
    end
    merchant:SetObjVar("Stock", stock)
end

--- Add an item to the merchants current stock
-- @param merchant(mobileObj)
-- @param position(number) The stock position of the sale item
-- @param object(gameObj) The item up for sale
-- @param stock(optional) The return value of GetMerchantStock
-- @return modified stock array(luaTable)
function AddToStock(merchant, position, object, stock)
    stock = stock or GetMerchantStock(merchant)
    stock[position] = object
    SetMerchantStock(merchant, stock)
    return stock
end

--- Builds an array to specified size containing all boolean false values representing zero stock
-- @param merchant(mobileObj)
-- @param size(number) the size of the StockData.ItemInventory
-- @return array of built stock(full of false boolean values) (luaTable) 
function SetInitialMerchantStock(merchant, size)
    local stock = {}
    for i=1,size do
        table.insert(stock, false)
    end
    SetMerchantStock(merchant, stock)
    return stock
end