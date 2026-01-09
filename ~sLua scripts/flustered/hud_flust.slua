--!nocheck
-- @diagnostic disable: undefined-global, unused-local
-- selene: allow(unused_variable)

local FLUSH_CHANNEL = 999

LLEvents:on("state_entry", function()
    ll.OwnerSay("hud ready. touch to trigger the effect.")
end)

LLEvents:on("touch_start", function(detected)
    local owner = ll.GetOwner()
    local payload = "FLUSHED:" .. tostring(owner)
    ll.RegionSay(FLUSH_CHANNEL, payload)
end)

LLEvents:on("on_rez", function(start_param)
    ll.ResetScript()
end)

LLEvents:on("attach", function(id)
    if id ~= NULL_KEY then
        ll.OwnerSay("hud attached. touch to trigger.")
    end
end)