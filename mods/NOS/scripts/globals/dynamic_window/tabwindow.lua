--[[ Adds a tab menu to the dynamic window
    Sample args:
        {
  	        ActiveTab = "Skill", 
            Width = 200,
            OffsetX = 200,
            OffsetY = 200,
            ButtonWidth = 94,
            Buttons = {
				{ Text = "Available", TabId = "Avail", Tooltip = "All unlocked titles."},
				{ Text = "Skill", TabId = "Skill", Tooltip = "Titles earned from gaining skill."},
            }
        }
--]]
function AddTabMenu(dynWindow,args)
	args.ActiveTab = args.ActiveTab or ""	
	args.OffsetX = args.OffsetX or 10
	args.OffsetY = args.OffsetY or 6
	args.ButtonWidth = args.ButtonWidth or 94
	args.Width = args.Width or ((#args.Buttons * args.ButtonWidth) + 6)

	dynWindow:AddImage(args.OffsetX,args.OffsetY + 2,"Tab_Bar",args.Width,0,"Sliced")

	if(args.Buttons) then
		local curX = args.OffsetX + 3
		for i,buttonArgs in pairs(args.Buttons) do
			if(buttonArgs.Text and buttonArgs.Text ~= "") then
				buttonArgs.TabId = buttonArgs.TabId or buttonArgs.Text
				if(buttonArgs.TabId == args.ActiveTab) then
					dynWindow:AddImage(curX,args.OffsetY,"Tab_Label",args.ButtonWidth,0,"Sliced")
				end
				dynWindow:AddButton(curX,args.OffsetY + 2,"SelectTab|"..buttonArgs.TabId,buttonArgs.Text,args.ButtonWidth,20,buttonArgs.Tooltip,"",false,"Text")
			end
			curX = curX + args.ButtonWidth
		end		
	end
end

function AddVerticalTabMenu(dynWindow,args)
	args.ActiveTab = args.ActiveTab or ""	
	args.OffsetX = args.OffsetX or 10
	args.OffsetY = args.OffsetY or 6
	args.ButtonHeight = args.ButtonHeight or 35
	args.Height = args.Height or ((#args.Buttons * args.ButtonHeight) + 6)

	if(args.Buttons) then
		local curY = args.OffsetY + 3
		for i,buttonArgs in pairs(args.Buttons) do
			if(buttonArgs.Text and buttonArgs.Text ~= "") then
				buttonArgs.TabId = buttonArgs.TabId or buttonArgs.Text
				if(buttonArgs.TabId == args.ActiveTab) then
					dynWindow:AddButton(args.OffsetX,curY,"SelectTab|"..buttonArgs.TabId,"",154,args.ButtonHeight,buttonArgs.Tooltip,"",false,"VerticalTab", "pressed")
				else
					dynWindow:AddButton(args.OffsetX,curY,"SelectTab|"..buttonArgs.TabId,"",150,args.ButtonHeight,buttonArgs.Tooltip,"",false,"VerticalTab")
				end
					dynWindow:AddLabel(args.OffsetX + 8,curY + 1 + 11,buttonArgs.TabId, 150, args.ButtonHeight,18,"left",false,false)
			end
			curY = curY + args.ButtonHeight
		end		
	end
end

function HandleTabMenuResponse(buttonId)
	if(buttonId ~= nil) then
		local prefix,tabId  = buttonId:match("(%a+)|(.+)")
		if(prefix == "SelectTab" and tabId ~= nil) then
			return tabId
		end
	end
end