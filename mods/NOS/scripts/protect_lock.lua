mMyProtBox = nil

RegisterEventHandler(EventType.Message, "PROTECT_LOCK", 
	function(MyProtBox)		
		mMyProtBox = MyProtBox
		--DebugMessage("Lock it Back!")
		
		if(mMyProtBox  ~= nil and mMyProtBox:IsValid()) then
			this:PathTo(mMyProtBox:GetLoc(), 1, "protBox")
		else
			this:DelModule("protect_lock")
		end
		--DebugMessage(this:GetName() .. " From: " .. mMyProtBox:GetName())
		this:NpcSpeech("Pesky Thieves!")
	end)

RegisterEventHandler(EventType.Arrived, "protBox", 
	function()
		if(mMyProtBox ~= nil and mMyProtBox:IsValid()) then
			mMyProtBox:SendMessage("Lock")
		end
	end)