-- This simple script will replace the name of an object with 
-- the contents of the objvar "name". 
-- Example: A sign seed object can specify the name to display
-- on the sign by specifying it in the seed object editor

newName = this:GetObjVar("name")
if(newName ~= nil) then
	this:SetName(newName)
	this:DelObjVar("name")
end
this:DelModule("name_replacer")
