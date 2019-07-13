RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
    		if (usedType ~= "Roll") then return end
	
		-- roll two dice and sum the result
		local roll1 = DiceRoll();
		local roll2 = DiceRoll();
		local sum = roll1 + roll2;

		-- build a sentence of the form "Name rolls a roll1 and a roll2 for a total of sum."
		local sentence = "[8EE55C]" .. user:GetName() .. " rolls a "
		sentence = sentence .. "[54B61C]" .. numberToSpeechCardinal(roll1) .. "[-] and a "
		sentence = sentence .. "[54B61C]" .. numberToSpeechCardinal(roll2) .. "[-] "
		sentence = sentence .. "for a total of [54B61C]" .. numberToSpeechCardinal(sum) .. "[-].[-]"

		-- add some surprise text for rolls on occasion
		if sum == 2 then
			if DiceRoll(1, 10) <= 5 then
				sentence = sentence .. "[8EE55C] Snake eyes![-]"
			end
		elseif sum == 3 then
			if DiceRoll(1, 10) <= 3 then
				sentence = sentence .. "[8EE55C] Ace caught a deuce![-]"
			end
		elseif sum == 4 then
			if DiceRoll(1, 10) <= 2 then
				sentence = sentence .. "[8EE55C] Ballerina![-]"
			end
		elseif sum == 7 then
			if DiceRoll(1, 10) <= 1 then
				sentence = sentence .. "[8EE55C] Craps![-]"
			end
		elseif sum == 8 then
			if roll1 == 4 and roll2 == 4 and DiceRoll(1, 10) <= 5 then
				sentence = sentence .. "[8EE55C] Pair of squares![-]"
			end
		elseif sum == twelve then
			if DiceRoll(1, 10) <= 5 then
				sentence = sentence .. "[8EE55C] Midnight![-]"
			end
		end
    	
		-- TODO: add the ability for objects to talk and not just mobs
		user:NpcSpeech(sentence)
	end)

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(),
	function ( ... )
		AddUseCase(this,"Roll", true)
		SetTooltipEntry(this,"cup of dice","Rolls a pair of dice in a cup.")
	end)
