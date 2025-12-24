integer listen_handle = 0;
integer DIALOG_CHANNEL = -12345; // private channel

default
{
    state_entry()
    {
        llOwnerSay("✨ Multi-Emotion HUD Ready!");
        llOwnerSay("Touch a button to trigger an emotion!");
    }

    touch_start(integer num)
    {
        key owner = llGetOwner();

        list options = [
            "Flushed",
            "Mind Blown",
            "Heart Eyes",
            "Sweatdrop",
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

        if (message == "Flushed")
        {
            llRegionSay(999, "EMOTION:FLUSHED:" + (string)owner);
            llOwnerSay("😳 Flushed activated!");
        }
        else if (message == "Mind Blown")
        {
            llRegionSay(999, "EMOTION:MINDBLOWN:" + (string)owner);
            llOwnerSay("🤯 Mind Blown activated!");
        }
        else if (message == "Heart Eyes")
        {
            llRegionSay(999, "EMOTION:HEARTEYES:" + (string)owner);
            llOwnerSay("😍 Heart Eyes activated!");
        }
        else if (message == "Sweatdrop")
        {
            llRegionSay(999, "EMOTION:SWEATDROP:" + (string)owner);
            llOwnerSay("😅 Sweatdrop activated!");
        }
        else if (message == "Nervous")
        {
            llRegionSay(999, "EMOTION:NERVOUS:" + (string)owner);
            llOwnerSay("😰 Nervous activated!");
        }
        else if (message == "Starry-Eyed")
        {
            llRegionSay(999, "EMOTION:STARRY:" + (string)owner);
            llOwnerSay("✨ Starry-Eyed activated!");
        }
        else
        {
            llOwnerSay("Unknown selection: " + message);
        }
    }
}