key tipJarKey = NULL_KEY;
integer COMM_CHANNEL = -8675310;
integer listenHandle;
integer autoRefresh = FALSE;
float refreshInterval = 30.0;

sendCommand(string command)
{
    if (tipJarKey == NULL_KEY)
    {
        llOwnerSay("Not connected to a tip jar. Touch HUD to connect.");
        return;
    }
    
    llRegionSayTo(tipJarKey, COMM_CHANNEL, "OWNER|" + command);
}

requestStats()
{
    sendCommand("GETSTATS");
}

showMainMenu()
{
    if (tipJarKey == NULL_KEY)
    {
        llDialog(llGetOwner(), "Owner HUD - Not Connected", 
                ["Connect"], COMM_CHANNEL);
    }
    else
    {
        list buttons = [
            "Stats", "Goal", "Reset",
            "Withdraw", "Auto", "X"
        ];
        
        string autoStatus = "";
        if (autoRefresh)
        {
            autoStatus = " [Auto ON]";
        }
        
        llDialog(llGetOwner(), "Tip Jar Owner Panel" + autoStatus + "\nConnected to: " + 
                llKey2Name(tipJarKey), buttons, COMM_CHANNEL);
    }
}

default
{
    state_entry()
    {
        llSetText("Owner HUD\nTouch to connect", <1, 0.8, 0>, 1.0);
        listenHandle = llListen(COMM_CHANNEL, "", "", "");
    }
    
    attach(key id)
    {
        if (id != NULL_KEY)
        {
            llOwnerSay("Owner HUD attached. Touch to manage your tip jar.");
        }
    }
    
    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) != llGetOwner()) return;
        
        if (tipJarKey == NULL_KEY)
        {
            llOwnerSay("Searching for your tip jars...");
            llSensor("", "", SCRIPTED, 96.0, PI);
        }
        else
        {
            showMainMenu();
        }
    }
    
    sensor(integer num)
    {
        if (num > 0)
        {
            list buttons = [];
            list jarKeys = [];
            integer i;
            integer found = 0;
            
            for (i = 0; i < num && found < 12; i++)
            {
                key objOwner = llList2Key(llGetObjectDetails(llDetectedKey(i), [OBJECT_OWNER]), 0);
                if (objOwner == llGetOwner())
                {
                    string objName = llDetectedName(i);
                    if (llSubStringIndex(llToLower(objName), "tip") != -1 || 
                        llSubStringIndex(llToLower(objName), "jar") != -1)
                    {
                        buttons += [objName];
                        jarKeys += [llDetectedKey(i)];
                        found++;
                    }
                }
            }
            
            if (found > 0)
            {
                llDialog(llGetOwner(), "Select your tip jar:", buttons, COMM_CHANNEL);
                llSetObjectDesc(llList2CSV(jarKeys));
            }
            else
            {
                llOwnerSay("No tip jars found nearby that you own.");
            }
        }
        else
        {
            llOwnerSay("No tip jars found nearby.");
        }
    }
    
    no_sensor()
    {
        llOwnerSay("No objects found nearby. Make sure you're close to your tip jar.");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (id != llGetOwner()) return;
        
        if (tipJarKey == NULL_KEY && llGetObjectDesc() != "")
        {
            list keys = llCSV2List(llGetObjectDesc());
            integer i;
            for (i = 0; i < llGetListLength(keys); i++)
            {
                key objKey = llList2Key(keys, i);
                if (llKey2Name(objKey) == message)
                {
                    tipJarKey = objKey;
                    llSetObjectDesc("");
                    llSetText("Connected:\n" + message, <0, 1, 0>, 1.0);
                    llOwnerSay("✅ Connected to " + message);
                    requestStats();
                    return;
                }
            }
        }
        
        if (message == "Connect")
        {
            llOwnerSay("Searching for your tip jars...");
            llSensor("", "", SCRIPTED, 96.0, PI);
        }
        else if (message == "Stats")
        {
            requestStats();
        }
        else if (message == "Goal")
        {
            llTextBox(llGetOwner(), "Enter goal amount (L$):", COMM_CHANNEL);
        }
        else if (message == "Reset")
        {
            llDialog(llGetOwner(), "Reset all statistics?\nThis cannot be undone!", 
                    ["Confirm Reset", "Cancel"], COMM_CHANNEL);
        }
        else if (message == "Confirm Reset")
        {
            sendCommand("RESET");
            llOwnerSay("Tip jar reset command sent.");
        }
        else if (message == "Withdraw")
        {
            sendCommand("WITHDRAW");
            llOwnerSay("Processing withdrawal...");
        }
        else if (message == "Auto")
        {
            autoRefresh = !autoRefresh;
            if (autoRefresh)
            {
                llSetTimerEvent(refreshInterval);
                llOwnerSay("Auto-refresh enabled (every " + (string)((integer)refreshInterval) + "s)");
            }
            else
            {
                llSetTimerEvent(0.0);
                llOwnerSay("Auto-refresh disabled.");
            }
        }
        else if (message == "X")
        {
            tipJarKey = NULL_KEY;
            autoRefresh = FALSE;
            llSetTimerEvent(0.0);
            llSetText("Owner HUD\nTouch to connect", <1, 0.8, 0>, 1.0);
            llOwnerSay("Disconnected from tip jar.");
        }
        else if (message == "Cancel")
        {
            llOwnerSay("Cancelled.");
        }
        else
        {
            integer amount = (integer)message;
            if (amount > 0)
            {
                sendCommand("SETGOAL|" + (string)amount);
                llOwnerSay("Goal set to L$" + (string)amount);
            }
        }
    }
    
    timer()
    {
        if (autoRefresh && tipJarKey != NULL_KEY)
        {
            requestStats();
        }
    }
}