
local index = #AutoFixes + 1
AutoFixes[index] = {}
AutoFixes[index].World = function(clusterController)
    GlobalVarDelete("Taxes", "DeleteTaxes")
end