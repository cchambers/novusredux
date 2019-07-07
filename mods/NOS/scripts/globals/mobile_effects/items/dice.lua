MobileEffectLibrary.DiceRoll = 
{

	OnEnterState = function(self,root,target,args)
		-- roll two dice and sum the result
		local roll1 = DiceRoll()
		local roll2 = DiceRoll()
		local sum = roll1 + roll2

		-- build a sentence of the form "Name rolls a roll1 and a roll2 for a total of sum."
		local sentence = "*" .. self.ParentObj:GetName() .. " rolls a " .. numberToSpeechCardinal(roll1) .. " and a " .. numberToSpeechCardinal(roll2) .. " for a total of " .. numberToSpeechCardinal(sum) .. "*"
		
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
    	
		-- target is the dice object that caused the roll
		if ( target and target:IsValid() and target:TopmostContainer() == nil ) then
			local nearbyPlayers = FindObjects(SearchPlayerInRange(10), target)
			for i=1,#nearbyPlayers do
				nearbyPlayers[i]:SystemMessage(sentence)
			end
		else
			self.ParentObj:SystemMessage(sentence)
		end

		EndMobileEffect(root)
	end,

}