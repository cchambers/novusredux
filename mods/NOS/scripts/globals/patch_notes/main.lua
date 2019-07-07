
PatchNotes = {
    CurrentVersion = "6.0.1.25",
    -- increment this each time to force an update (even if changing current version)
    Incr = 1,
    Patches = {}
}

require 'globals.patch_notes.6.0.1.25'

function ShowPatchNotes(user, checked)
    if ( user ) then
        local incr = user:GetObjVar("PatchNotesIncr")
        if ( incr ~= PatchNotes.Incr ) then
			if ( checked ~= true ) then checked = false end
            
            local windowWidth = 520
            local windowHeight = 600

            local padding = 20
            
            local dynamicWindow = DynamicWindow(
                "PatchNotes", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
                "Patch Notes", --(string) Title of the window for the client UI
                windowWidth, --(number) Width of the window
                windowHeight --(number) Height of the window
                --startX, --(number) Starting X position of the window (chosen by client if not specified)
                --startY, --(number) Starting Y position of the window (chosen by client if not specified)
                --windowType, --(string) Window type (optional)
                --windowAnchor --(string) Window anchor (default "TopLeft")
            )

            dynamicWindow:AddLabel(
                padding, --(number) x position in pixels on the window
                padding, --(number) y position in pixels on the window
                PatchNotes.Patches[PatchNotes.CurrentVersion], --(string) text in the label
                windowWidth-(padding*2), --(number) width of the text for wrapping purposes (defaults to width of text)
                windowHeight-(padding*2)-90, --(number) height of the label (defaults to unlimited, text is not clipped)
                20, --(number) font size (default specific to client)
                "left", --(string) alignment "left", "center", or "right" (default "left")
                true --(boolean) scrollable (default false)
                --false, --(boolean) outline (defaults to false)
                --"" --(string) name of font on client (optional)
			)

				
			dynamicWindow:AddButton(
				padding, --(number) x position in pixels on the window
				windowHeight-85, --(number) y position in pixels on the window
				"DontShowAgain", --(string) return id used in the DynamicWindowResponse event
				"", --(string) text in the button (defaults to empty string)
				0, --(number) width of the button (defaults to width of text)
				18,--(number) height of the button (default decided by type of button)
				"", --(string) mouseover tooltip for the button (default blank)
				"", --(string) server command to send on button click (default to none)
				false,--closeWindowOnClick, --(boolean) should the window close when this button is clicked? (default true)
				"Selection", --buttonType, --(string) button type (default "Default")
				(checked and "pressed") or "" --(string) button state (optional, valid options are default,pressed,disabled)
				--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
			)

            dynamicWindow:AddLabel(
                padding+30, --(number) x position in pixels on the window
                windowHeight-80, --(number) y position in pixels on the window
                "Don't show these notes on next login.", --(string) text in the label
                windowWidth-(padding*2), --(number) width of the text for wrapping purposes (defaults to width of text)
                0, --(number) height of the label (defaults to unlimited, text is not clipped)
                20, --(number) font size (default specific to client)
                "left", --(string) alignment "left", "center", or "right" (default "left")
                true --(boolean) scrollable (default false)
                --false, --(boolean) outline (defaults to false)
                --"" --(string) name of font on client (optional)
			)

			RegisterSingleEventHandler(EventType.DynamicWindowResponse, "PatchNotes", function(user, button)
				if ( button == "DontShowAgain" ) then
					ShowPatchNotes(user, true)
					user:SetObjVar("PatchNotesIncr", PatchNotes.Incr)
				end
			end)

            user:OpenDynamicWindow(dynamicWindow)


        end
    end
end