require 'NOS:ai_npc_worker'

thingsToSay = {
    "Do not disturb, no? I'm working.",
    "I am busy doing job, comrade.",
    "Talk to the boss if you want to talk.",
    "I am on clock, yes? Talk to Clarabelle.",
    "Miners's Union no like slack, talk to Clara.",
    "Go away now.",
    "Leave comrade, I busy.",
    "Go away, I busy comrade.",
}

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Interact") then return end
        this:NpcSpeech(thingsToSay[math.random(1,#thingsToSay)])
    end)

RegisterSingleEventHandler(EventType.ModuleAttached, "ai_quarry_miner", 
	function ()
		if( initializer.Names ~= nil ) then
			local newName = initializer.Names[math.random(#initializer.Names)]
			this:SetName(newName)
		end
	end)

RegisterEventHandler(EventType.Message, "DamageInflicted", 
function (damager,damageAmt)    
    if (not AI.IsValidTarget(damager)) then return end
    --if I'm outside the ruins don't change faction
   -- 
        --but attack anyone that attack's my comrades
    local nearbyMiners = FindObjects(SearchMulti(
    {
        SearchMobileInRange(20), --in 10 units
        SearchModule("ai_quarry_miner"),
    }))
    for i,j in pairs (nearbyMiners) do
        if (not IsInCombat(j)) then
                --DebugMessage("attacking enemy")
                j:SendMessage("AttackEnemy",damager) --defend me
            end
        end
    end)
