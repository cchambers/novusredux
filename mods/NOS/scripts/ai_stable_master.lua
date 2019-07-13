require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = true
AI.Settings.EnableBuy = true
fixPrice = 20

NPCTasks = {
    
}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"I can hold onto your pets for you, just say the word!"
}

AI.CantAffordPurchaseMessages = {
	"What do I look like a charity?",
	"I'm not giving horses away here pal"
}

function Dialog.OpenGreetingDialog(user)
    text = AI.GreetingMessages[math.random(1,#AI.GreetingMessages)]

    response = {}

    response[1] = {}
    response[1].text = "I'd like to purchase a horse."
    response[1].handle = "Purchase"

    response[2] = {}
    response[2].text = "My pet please."
    response[2].handle = "Pet"

    response[3] = {}
    response[3].text = "Stable my pet."
    response[3].handle = "Stable"

    response[4] = {}
    response[4].text = "Who are you?"
    response[4].handle = "Who"

    if (AI.GetSetting("EnableTrain") ~= nil and AI.GetSetting("EnableTrain") == true and CanTrain()) then
        response[5] = {}
        response[5].text = "Will you teach me about animals?"
        response[5].handle = "Train" 
    end

    response[6] = {}
    response[6].text = "Goodbye."
    response[6].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenPurchaseDialog(user)
    text = "Sure. Just let me know which one you would like to buy.\n\n(Double-click the horse)"

    response = {}

    response[1] = {}
    response[1].text = "Ok."
    response[1].handle = ""

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function IntroDialog(user)
	Dialog.OpenGreetingDialog(user)

    --GetAttention(user)
end

function RetrievePet(user, petid)

end

function Dialog.OpenPetDialog(user)
	local pets, slots = GetStabledPets(user)
	if ( #pets > 0 ) then
		ShowSelectStabledPetsWindow(user, pets)
	else
		this:NpcSpeech("I ain't got a pet for you buddy.")
	end
end

function Dialog.OpenStableDialog(user)
	this:NpcSpeech("Show me the animal!")
	user:RequestClientTargetGameObj(this, "TargetStableAnimal")
end

function Dialog.OpenWhoDialog(user)
    QuickDialogMessage(this,user,"I am a stable master. For only 50 gold your pet will be kept safe until you ask for them back. You can stable a maximum of "..MaxStabledPetSlots(user).." pets.")
end

function Dialog.OpenTalkDialog(user)
    QuickDialogMessage(this,user,"Bother the Gods with your troubles, I deal in crap all day.")
end

function ShowSelectStabledPetsWindow(user, pets)
	buttonList = {}
	for i,pet in pairs(pets) do
		table.insert(buttonList,{Id=tostring(pet.Id),Text=StripColorFromString(pet:GetName())})
	end

	ButtonMenu.Show{
        TargetUser = user,
        DialogId = "unstable",
        TitleStr = "Unstable Pet",
        ResponseType = "id",
        Buttons = buttonList,
        ResponseObj = this,
        ResponseFunc = function(user,buttonId)
        	if(buttonId ~= nil) then
            	local pet = GetStabledPetById(user, tonumber(buttonId))
				if ( pet ~= nil ) then
					-- make sure they have the room left for this pet before we give it to them.
					local max = MaxActivePetSlots(user)
					local remaining = GetRemainingActivePetSlots(user)
					local active = max - remaining
					if ( (pet:GetObjVar("PetSlots") or max) > remaining ) then
						this:NpcSpeech("Methinks you could not control yet another pet.")
						user:SystemMessage(tostring("Active: " .. active .. ", Max: " .. max))
					else
						pet:SendMessage("Unstable")
						this:NpcSpeech("Here you go!")
					end
				end
            end
        end,
    }  
end

function Merchant.DoCantAfford(buyer)
	QuickDialogMessage(this,buyer,AI.CantAffordPurchaseMessages[math.random(1,#AI.CantAffordPurchaseMessages)], 30)
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "TargetStableAnimal", function(target, user)
		if ( not(IsTamable(target)) ) then
			this:NpcSpeech("That's not something I can take care of.")
		else
			if ( this:GetLoc():Distance(target:GetLoc()) > 30 ) then
				user:SystemMessage("That animal is too far away from the stable master.", "info")
			else
				local pet = GetActivePetById(user, target.Id)
				if ( pet == nil ) then
					user:SystemMessage("Hey, what are you trying to pull!", "info")
				else
					local stabledPets, stabledSlots = GetStabledPets(user)
					if ( stabledSlots + 1 >= MaxStabledPetSlots(user) ) then
						this:NpcSpeech("I cannot take anymore of your pets.")
					else
						local backpack = target:GetEquippedObject("Backpack")
						if ( backpack and #backpack:GetContainedObjects() > 0 ) then
							this:NpcSpeech("That pet is carrying stuff, I'm not a bank!")
						else
							RequestConsumeResource(user, "coins", 50, "StablePet", this, pet)
						end
					end
				end
			end
		end
	end)
	
RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
    function (success,transactionId,user,pet)
        if ( pet ~= nil and transactionId == "StablePet" ) then
            if not(success) then
                user:SystemMessage("Not enough gold to stable your pet.", "info")
            else
                user:SystemMessage("50 gold paid to stable your pet.", "info")
				pet:SendMessage("Stable")
				this:NpcSpeech("Your pet is safe with me.")
            end
        end
    end)