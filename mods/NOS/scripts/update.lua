
SetItemTooltip(this)
CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
    this:DelModule("update")
end)