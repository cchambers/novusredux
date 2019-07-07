if(initializer ~= nil) then
	--Sets a random size of the gem, along with it's value
	MIN_SIZE = 0.3
	MAX_SIZE = 1.0
	if (this:HasObjVar("Valuable")) then
		local value = this:GetObjVar("Valuable")
		local minsize = MIN_SIZE * 100
		local maxsize = MAX_SIZE * 100
		local scale = math.random(minsize,maxsize)/100
		this:SetScale(Loc(scale,scale,scale))
		if (scale <= 0.5) then
			this:SetName("Crude "..this:GetName())
		elseif (scale <= 0.6) then
			this:SetName("Imperfect "..this:GetName())
		elseif (scale <= 0.7) then
			this:SetName("Blemished "..this:GetName())
		elseif (scale <= 0.8) then
			this:SetName("Flawless "..this:GetName())
		elseif (scale <= 0.9) then
			this:SetName("Perfect "..this:GetName())
		else
			this:SetName("Priceless "..this:GetName())
		end
		value = scale*value
		this:SetObjVar("Valuable",value)
	end
end