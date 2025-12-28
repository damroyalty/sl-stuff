integer listen_handle = 0;
integer DIALOG_CHANNEL = -12345; // private channel for dialog responses

default
{
    state_entry()
    {
        llOwnerSay("✨ multi-emotion hud ready!");
        llOwnerSay("touch a button to trigger an emotion!");
    }

    touch_start(integer num)
    {
        key owner = llGetOwner();

        list options = [
            "Flustered",
            "Mind Blown",
            "Heart Eyes",
            "Awkward",
            "Nervous",
            "Starry-Eyed",
            "Close"
        ];
        if (listen_handle != 0) llListenRemove(listen_handle);
        listen_handle = llListen(DIALOG_CHANNEL, "", owner, "");

        llDialog(owner, "Select an emotion:", options, DIALOG_CHANNEL);
    }

    listen(integer channel, string name, key id, string message)
    {
        key owner = id;

        if (channel != DIALOG_CHANNEL) return;

        if (listen_handle != 0)
        {
            llListenRemove(listen_handle);
            listen_handle = 0;
        }

        if (message == "Close")
        {
            llOwnerSay("Menu closed.");
            return;
        }

        if (message == "Flustered")
        {
            llRegionSay(999, "EMOTION:FLUSHED:" + (string)owner);
        }
        else if (message == "Mind Blown")
        {
            llRegionSay(999, "EMOTION:MINDBLOWN:" + (string)owner);
        }
        else if (message == "Heart Eyes")
        {
            llRegionSay(999, "EMOTION:HEARTEYES:" + (string)owner);
        }
        else if (message == "Awkward")
        {
            llRegionSay(999, "EMOTION:SWEATDROP:" + (string)owner);
        }
        else if (message == "Nervous")
        {
            llRegionSay(999, "EMOTION:NERVOUS:" + (string)owner);
        }
        else if (message == "Starry-Eyed")
        {
            llRegionSay(999, "EMOTION:STARRY:" + (string)owner);
        }
        else
        {
            llOwnerSay("Unknown selection: " + message);
        }
    }
}