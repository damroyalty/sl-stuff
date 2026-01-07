default
{
    state_entry()
    {
        llOwnerSay("hud ready. touch to trigger the effect.");
    }

    touch_start(integer total_number)
    {
        key owner = llGetOwner();
        string payload = "FLUSHED:" + (string)owner;
        llRegionSay(999, payload);
    }

    on_rez(integer param)
    {
        llResetScript();
    }

    attach(key id)
    {
        if (id != NULL_KEY)
        {
            llOwnerSay("hud attached. touch to trigger.");
        }
    }
}
