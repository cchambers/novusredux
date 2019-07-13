
userTeam = nil
RegisterEventHandler(EventType.ClientTargetGameObjResponse,"team",
	function (target,user)
		if(target ~= nil) then
			local nameColor = COLORS[userTeam]
			target:SetObjVar("NameColorOverride",nameColor)
			target:SendMessage("UpdateName")
			target:SystemMessage("You have joined the "..userTeam.." team.")
		end
	end)

-- CUSTOM TWOTOWERS Code
RegisterEventHandler(EventType.ClientUserCommand,"team",
	function (team)
		if not(team) then
			teamColorStr = ""
			for i,color in COLORS do 
				teamColorStr = teamColorStr .. ","
			end
			teamColorStr = StripTrailingComma(teamColorStr)
			this:SystemMessage("Team Colors: "..teamColorStr)
			return
		end

		userTeam = team
		this:RequestClientTargetGameObj(this, "team")
	end)


RegisterEventHandler(EventType.Message,"UseObject",
	function (user,usedType)
		if(usedType == "Join Team") then
			local teamName = this:GetObjVar("Team")
			local nameColor = COLORS[teamName]
			user:SetObjVar("NameColorOverride",nameColor)
			user:SendMessage("UpdateName")
			user:SystemMessage("You have joined the "..teamName.." team.")
		elseif(usedType == "Leave Team") then
			local teamName = this:GetObjVar("Team")
			user:DelObjVar("NameColorOverride")
			user:SendMessage("UpdateName")
			user:SystemMessage("You have left the "..teamName.." team.")
		elseif(usedType == "Change Team" and IsImmortal(user)) then
			TextFieldDialog.Show{
		        TargetUser = user,
		        ResponseObj = this,
		        Title = "Change Team",
		        ResponseFunc = function(user,newValue)
		            if(newValue ~= nil and COLORS[newValue]) then
		                this:SetObjVar("Team",newValue)
		                this:SetColor(COLORS[newValue])
		                this:SetName("["..COLORS[newValue] .. "] Join "..newValue.." Team[-]" )
		            end
		        end
		    }
		end
	end)


RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function()
		AddUseCase(this,"Join Team",true)	
		AddUseCase(this,"Leave Team",false)	
		AddUseCase(this,"Change Team",false,"IsImmortal")	
	end)
