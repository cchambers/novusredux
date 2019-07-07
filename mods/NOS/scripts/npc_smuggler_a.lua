require 'npc_smuggler_b'

OverrideEventHandler("npc_smuggler_b",EventType.DynamicWindowResponse,"Responses",function (user,buttonID)
	if( user == nil or not user:IsValid()) then return end
	if (not CanUseNPC(user)) then return end
	if (buttonID == "SpawnPortal") then
	    this:NpcSpeech("[$3318]")
	    this:PlayAnimation("cast_heal")
	    if (this:GetObjVar("Portal") == nil or not this:GetObjVar("Portal"):IsValid()) then
	        CreateObj("teleporter_to_celador_smuggler",Loc(216.75, 0, 15.79),"portal_created")
	    end
	elseif (buttonID == "Why") then
		QuickDialogMessage(this,user,"[$3319]")
	elseif (buttonID == "Nevermind") then
		
		text="What do you want then?"

		response = {}

		response[1] = {}
		response[1].text = "Why are you helping me?"
		response[1].handle = "Why" 

		response[4] = {}
		response[4].text = "Goodbye."
		response[4].handle = "" 

		NPCInteraction(text,this,user,"Responses",response)
	end
end)