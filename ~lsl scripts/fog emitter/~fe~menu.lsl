integer MENU_CHANNEL;
integer menuHandle;
key menuUser;

integer currentPage = 1;  // 1 = main menu, 2 = direction menu, 3 = advanced menu

showMainMenu(key user)
{
    menuUser = user;
    MENU_CHANNEL = -1 - (integer)llFrand(1000000);
    menuHandle = llListen(MENU_CHANNEL, "", user, "");
    
    list buttons = [
        "ON", "OFF",
        "Density +", "Density -",
        "Particles +", "Particles -",
        "Direction >>", "RESET", "CLOSE"
    ];
    
    llDialog(user, 
        "\n=== FOG CONTROL ===\n\nMain Controls\n\nUse buttons to control fog settings",
        buttons, 
        MENU_CHANNEL);
    
    currentPage = 1;
    llSetTimerEvent(60.0);
}

showDirectionMenu(key user)
{
    menuUser = user;
    MENU_CHANNEL = -1 - (integer)llFrand(1000000);
    menuHandle = llListen(MENU_CHANNEL, "", user, "");
    
    list buttons = [
        "North", "South",
        "East", "West",
        "NE", "NW",
        "SE", "SW", "Up",
        "<< Back", "Advanced >>", "CLOSE"
    ];
    
    llDialog(user, 
        "\n=== FOG DIRECTION ===\n\nChoose fog rolling direction\n\nCardinal & Diagonal Directions",
        buttons, 
        MENU_CHANNEL);
    
    currentPage = 2;
    llSetTimerEvent(60.0);
}

showAdvancedMenu(key user)
{
    menuUser = user;
    MENU_CHANNEL = -1 - (integer)llFrand(1000000);
    menuHandle = llListen(MENU_CHANNEL, "", user, "");
    
    list buttons = [
        "Speed +", "Speed -",
        "Rise +", "Rise -",
        " ", " ",
        "<< Back", " ", "CLOSE"
    ];
    
    llDialog(user, 
        "\n=== ADVANCED SETTINGS ===\n\nAdjust fog movement speeds\n\nSpeed = Horizontal roll speed\nRise = Vertical lift speed",
        buttons, 
        MENU_CHANNEL);
    
    currentPage = 3;
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
            
            // main menu buttons
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
            else if (message == "Direction >>")
            {
                showDirectionMenu(id);
            }
            else if (message == "RESET")
            {
                llMessageLinked(LINK_THIS, 0, "RESET", "");
                showMainMenu(id);
            }
            
            // direction menu buttons
            else if (message == "North")
            {
                llMessageLinked(LINK_THIS, 0, "ROLL_NORTH", "");
                showDirectionMenu(id);
            }
            else if (message == "South")
            {
                llMessageLinked(LINK_THIS, 0, "ROLL_SOUTH", "");
                showDirectionMenu(id);
            }
            else if (message == "East")
            {
                llMessageLinked(LINK_THIS, 0, "ROLL_EAST", "");
                showDirectionMenu(id);
            }
            else if (message == "West")
            {
                llMessageLinked(LINK_THIS, 0, "ROLL_WEST", "");
                showDirectionMenu(id);
            }
            else if (message == "Up")
            {
                llMessageLinked(LINK_THIS, 0, "ROLL_UP", "");
                showDirectionMenu(id);
            }
            else if (message == "NE")
            {
                llMessageLinked(LINK_THIS, 0, "NORTHEAST", "");
                showDirectionMenu(id);
            }
            else if (message == "NW")
            {
                llMessageLinked(LINK_THIS, 0, "NORTHWEST", "");
                showDirectionMenu(id);
            }
            else if (message == "SE")
            {
                llMessageLinked(LINK_THIS, 0, "SOUTHEAST", "");
                showDirectionMenu(id);
            }
            else if (message == "SW")
            {
                llMessageLinked(LINK_THIS, 0, "SOUTHWEST", "");
                showDirectionMenu(id);
            }
            else if (message == "Advanced >>")
            {
                showAdvancedMenu(id);
            }
            
            // advanced menu buttons
            else if (message == "Speed +")
            {
                llMessageLinked(LINK_THIS, 0, "SPEED_UP", "");
                showAdvancedMenu(id);
            }
            else if (message == "Speed -")
            {
                llMessageLinked(LINK_THIS, 0, "SPEED_DOWN", "");
                showAdvancedMenu(id);
            }
            else if (message == "Rise +")
            {
                llMessageLinked(LINK_THIS, 0, "RISE_UP", "");
                showAdvancedMenu(id);
            }
            else if (message == "Rise -")
            {
                llMessageLinked(LINK_THIS, 0, "RISE_DOWN", "");
                showAdvancedMenu(id);
            }
            else if (message == "<< Back")
            {
                if (currentPage == 2)
                    showMainMenu(id);
                else if (currentPage == 3)
                    showDirectionMenu(id);
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