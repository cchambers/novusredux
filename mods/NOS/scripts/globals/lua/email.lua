local configFilePath = "emailsettings.cfg"

BUG_REPORT_EMAIL = "contact@citadelstudios.net"

-- NOTE: Settings values can not contain equals character
email_settings = {}
if(file_exists(configFilePath)) then	
	for line in io.lines(configFilePath) do
		local args = StringSplit(line,"=")
		if(#args == 2) then
			email_settings[args[1]] = args[2]
		end
	end
	if(email_settings.port) then
		email_settings.port = tonumber(email_settings.port)
	end
	
	smtp = LoadExternalModule ("smtp")	
	mime = LoadExternalModule ("mime")	
end

-- TODO: BUG: Handle empty recipient, subject, or body
-- REFACTOR: API: Don't send directly from the game server
function SendEmail(recipient,subject,body)
	if(smtp) then		
		local rcpt = {
			recipient		
		}

		local mesgt = {
			headers = {
				from = email_settings.from,
				to = recipient,			 	
		    	subject = subject
		  	},
			--[[body =
			   "Region="	..regionAddress.."\n"
			.."Map=" 		..worldName.."\n"
			.."UtcTime="	..realtime.."\n" 	-- Real Time Utc
			.."Gametime="	..gametime.."\n"	-- In Game Time
			.."Player="		..playerId.."\n"  -- Player Id
			.."PC="			..name.."\n" 		-- PC Name
			.."Location="	..location.."\n" 	-- In game Location
			.."Facing="	    ..facing.."\n" 	-- PC facing Angle (0=N, +=CW)
			.."Message="	..text.."\n" 		-- messagetext
			.."\n",]]
			body=body
		}

		r, e = smtp.send{
		  from = email_settings.from,
		  rcpt = rcpt, 
		  source = smtp.message(mesgt),
		  user=email_settings.user,
		  password=email_settings.password,
		  server=email_settings.host,
		  port=email_settings.port
		}		

		return true
	end
end
--SendEmail("contact@citadelstudios.net","TEST","This is a test")
