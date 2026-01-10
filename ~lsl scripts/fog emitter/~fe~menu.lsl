integer MENU_CHANNEL;
integer COMM_CHANNEL = -98765;
integer menuHandle;
key menuUser;

showMainMenu(key user)
{
    menuUser = user;
    MENU_CHANNEL = -1 - (integer)llFrand(1000000);
    menuHandle = llListen(MENU_CHANNEL, "", user, "");
    
    list buttons = [
        "ON", "OFF",
        "Density +", "Density -",
        "Particles +", "Particles -",
        "RESET", "CLOSE"
    ];
    
    llDialog(user, 
        "\n=== FOG CONTROL ===\n\nUse buttons to control fog settings",
        buttons, 
        MENU_CHANNEL);
    
    llSetTimerEvent(60.0);
}

default
{
    state_entry()
    {
        llOwnerSay("fog control is ready, touch to open menu");
    }
    
    touch_start(integer num)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            showMainMenu(llDetectedKey(0));
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (channel == MENU_CHANNEL)
        {
            llListenRemove(menuHandle);
            llSetTimerEvent(0.0);
            
            if (message == "ON")
            {
                llMessageLinked(LINK_THIS, 0, "FOG_ON", "");
                showMainMenu(id);
            }
            else if (message == "OFF")
            {
                llMessageLinked(LINK_THIS, 0, "FOG_OFF", "");
                showMainMenu(id);
            }
            else if (message == "Density +")
            {
                llMessageLinked(LINK_THIS, 0, "DENSITY_UP", "");
                showMainMenu(id);
            }
            else if (message == "Density -")
            {
                llMessageLinked(LINK_THIS, 0, "DENSITY_DOWN", "");
                showMainMenu(id);
            }
            else if (message == "Particles +")
            {
                llMessageLinked(LINK_THIS, 0, "PARTICLES_UP", "");
                showMainMenu(id);
            }
            else if (message == "Particles -")
            {
                llMessageLinked(LINK_THIS, 0, "PARTICLES_DOWN", "");
                showMainMenu(id);
            }
            else if (message == "RESET")
            {
                llMessageLinked(LINK_THIS, 0, "RESET", "");
                showMainMenu(id);
            }
            else if (message == "CLOSE")
            {
                llOwnerSay("Menu closed");
            }
        }
    }
    
    timer()
    {
        llListenRemove(menuHandle);
        llSetTimerEvent(0.0);
    }
}