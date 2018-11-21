
require 'incl_player_titles'

mUser = nil

--option to set them up from the initalizer instead
if initializer ~= nil and initializer.Recipe ~= nil then
	this:SetObjVar("Recipe",initializer.Recipe)
end

if initializer ~= nil and initializer.RecipeDisplayName ~= nil then
	this:SetObjVar("RecipeDisplayName",initializer.RecipeDisplayName)
end

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		return false
	end

	if( this:TopmostContainer() ~= user ) then
		user:SystemMessage("[$2428]")
		return false
	end

	if not(this:HasObjVar("Recipe")) then 
		user:SystemMessage("[F7CC0A] Invalid Recipe")
		return false
	end

	if (HasRecipe(user,this:GetObjVar("Recipe"))) then
		user:SystemMessage("You have already memorized this recipe.")
  		return false
    end

	local recipeTable = GetRecipeFromEntryName(this:GetObjVar("Recipe"))
    local recipeSkill = GetSkillForRecipe(this:GetObjVar("Recipe"))

	return true
end

function MemorizeDialogResponse(user,buttonId)	
	buttonId = tonumber(buttonId)
	
	if( user ~= mUser ) then
		return
	end

	if (buttonId == 0 and ValidateUse(user)) then		
		mySpell = this:GetObjVar("Recipe")			
		
		user:SystemMessage("[F7CC0A] You attempt to commit the "..this:GetName().." to memory.")
		MemorizeRecipe(user, mySpell, this)			
	else
		mUser = nil
	end	
end

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Memorize" and usedType ~= "Use") then return end
		-- using without canceling previous? odd
		if (mUser ~= nil) then
			if(mUser == user) then
				return
			end
		end
		if not(ValidateUse(user)) then
			return
		end
		mySpell = this:GetObjVar("Recipe")

		ClientDialog.Show{
			TargetUser = user,
			DialogId = "UseScroll",
			TitleStr = "Memorize Recipe",
			DescStr = "Do you wish to commit this "..this:GetName().." to memory?",
			ResponseObj = this,
			ResponseFunc = MemorizeDialogResponse,
		}

		mUser = user
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
	function()		
		AddUseCase(this,"Memorize",true,"HasObject")
		-- give other scripts some time to add bonuses before we update the tooltip
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "DelayedTooltipUpdate")	

		local recipeName = this:GetObjVar("RecipeDisplayName")
		if( recipeName ~= nil ) then	
			local tooltipString = "A recipe for creating a "..recipeName.."."

			local recipeTable = GetRecipeFromEntryName(this:GetObjVar("Recipe"))
			if (recipeTable ~= nil) then
			   	local productLevel = recipeTable.ProductLevel or 0
			   	if (productLevel ~= 0) then
			   		tooltipString = tooltipString .. "\n[E07B07]Pledge-Level Restricted Item[-]"
			   	end
		 	end

			SetTooltipEntry(this,"recipe",tooltipString)
		end
	end)

function MemorizeRecipe(user,recipe,recipeSource)
	local userRecipes = (user:GetObjVar("AvailableRecipies") or {})
	user:SystemMessage("[$2430]".. GetItemNameFromRecipe(recipe) .. "[-]","event")
	user:SystemMessage("[$2431]")
	userRecipes[recipe] = true

	PlayerTitles.CheckTitleGain(user,AllTitles.ActivityTitles.Recipes,#userRecipes)

	user:SetObjVar("AvailableRecipies",userRecipes)
	this:Destroy()
end