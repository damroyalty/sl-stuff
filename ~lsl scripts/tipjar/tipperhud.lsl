key tipJarKey = NULL_KEY;
integer COMM_CHANNEL = -8675309;
integer listenHandle;
integer anonymous = FALSE;

processTip(integer amount)
{
    if (tipJarKey == NULL_KEY)
    {
        llOwnerSay("Not connected to a tip jar. Touch HUD to connect.");
        return;
    }
    
    if (amount <= 0)
    {
        llOwnerSay("Invalid tip amount.");
        return;
    }
    
    llGiveMoney(llGetOwner(), amount);
    
    string tipMsg = "TIP|" + (string)amount + "|" + (string)anonymous;
    llRegionSayTo(tipJarKey, COMM_CHANNEL, tipMsg);
    
    string confirmMsg = "Sent L$" + (string)amount + " tip";
    if (anonymous)
    {
        confirmMsg += " (anonymously)";
    }
    llOwnerSay(confirmMsg + "!");
    
    llSetAlpha(0.5, ALL_SIDES);
    llSleep(0.1);
    llSetAlpha(1.0, ALL_SIDES);
}

default
{
    state_entry()
    {
        llSetText("Tip Jar HUD\nTouch to connect", <1, 1, 1>, 1.0);
        listenHandle = llListen(COMM_CHANNEL, "", "", "");
    }
    
    attach(key id)
    {
        if (id != NULL_KEY)
        {
            llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        }
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_DEBIT)
        {
            llOwnerSay("Tipper HUD ready! Touch to connect to a tip jar.");
        }
    }
    
    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) != llGetOwner()) return;
        
        if (tipJarKey == NULL_KEY)
        {
            llOwnerSay("Click the tip jar you want to connect to within 30 seconds.");
            llSensor("", "", SCRIPTED, 96.0, PI);
            llSetTimerEvent(30.0);
        }
        else
        {
            string anonButton;
            if (anonymous)
            {
                anonButton = "Anon:ON";
            }
            else
            {
                anonButton = "Anon:OFF";
            }
            
            list buttons = [
                "L$10", "L$25", "L$50",
                "L$100", "L$200", "L$500",
                "Custom", anonButton, "X"
            ];
            
            string dialogText = "Select tip amount:";
            if (anonymous)
            {
                dialogText += "\nAnonymous Mode ON";
            }
            
            llDialog(llGetOwner(), dialogText, buttons, COMM_CHANNEL);
        }
    }
    
    sensor(integer num)
    {
        if (num > 0)
        {
            list buttons = [];
            list names = [];
            integer i;
            
            for (i = 0; i < num && i < 12; i++)
            {
                string objName = llDetectedName(i);
                buttons += [objName];
                names += [llDetectedKey(i)];
            }
            
            llDialog(llGetOwner(), "Select tip jar to connect:", buttons, COMM_CHANNEL);
            
            llSetObjectDesc(llList2CSV(names));
        }
        else
        {
            llOwnerSay("No tip jars found nearby. Make sure you're close to the tip jar.");
        }
        
        llSetTimerEvent(0.0);
    }
    
    no_sensor()
    {
        llOwnerSay("No tip jars found nearby.");
        llSetTimerEvent(0.0);
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
                    llSetText("Connected to:\n" + message, <0, 1, 0>, 1.0);
                    llOwnerSay("Connected to " + message);
                    return;
                }
            }
        }
        
        if (message == "X")
        {
            tipJarKey = NULL_KEY;
            llSetText("Tip Jar HUD\nTouch to connect", <1, 1, 1>, 1.0);
            llOwnerSay("Disconnected from tip jar.");
        }
        else if (llGetSubString(message, 0, 4) == "Anon:")
        {
            anonymous = !anonymous;
            string status;
            if (anonymous)
            {
                status = "ON";
            }
            else
            {
                status = "OFF";
            }
            llOwnerSay("Anonymous mode: " + status);
        }
        else if (message == "Custom")
        {
            llTextBox(llGetOwner(), "Enter custom tip amount (L$):", COMM_CHANNEL);
        }
        else if (llGetSubString(message, 0, 1) == "L$")
        {
            integer amount = (integer)llGetSubString(message, 2, -1);
            processTip(amount);
        }
        else
        {
            integer amount = (integer)message;
            if (amount > 0)
            {
                processTip(amount);
            }
            else
            {
                llOwnerSay("Invalid tip amount.");
            }
        }
    }
    
    timer()
    {
        llSetTimerEvent(0.0);
        llOwnerSay("Connection timeout. Please try again.");
    }
}