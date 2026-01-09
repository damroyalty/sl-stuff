integer LISTEN_CHANNEL;
integer listenHandle;
list topTippers = [];
integer totalTipped = 0;
integer uniqueTippers = 0;
integer tipCount = 0;
float averageTip = 0.0;
integer goalAmount = 1000;
integer goalEnabled = TRUE;

showParticles(integer amount)
{
    integer burstCount = 5;
    float burstRadius = 0.5;
    vector color = <1, 0.8, 0.2>;

    if (amount >= 200)
    {
        burstCount = 20;
        burstRadius = 1.5;
        color = <1, 0.2, 0.8>;
    }

    llParticleSystem([
        PSYS_PART_FLAGS,
            PSYS_PART_EMISSIVE_MASK |
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_INTERP_SCALE_MASK,
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_PART_START_COLOR, color,
        PSYS_PART_END_COLOR, <1, 1, 1>,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.0,
        PSYS_PART_START_SCALE, <0.1, 0.1, 0.0>,
        PSYS_PART_END_SCALE, <0.05, 0.05, 0.0>,
        PSYS_PART_MAX_AGE, 2.0,
        PSYS_SRC_BURST_PART_COUNT, burstCount,
        PSYS_SRC_BURST_RADIUS, burstRadius,
        PSYS_SRC_BURST_RATE, 0.1,
        PSYS_SRC_MAX_AGE, 0.5
        ]);

    llSetTimerEvent(2.5);
}

updateLeaderboard(string name, integer amount)
{
    integer i;
    integer found = FALSE;

    for (i = 0; i < llGetListLength(topTippers); i += 2)
    {
        if (llList2String(topTippers, i) == name)
        {
            integer oldAmount = llList2Integer(topTippers, i + 1);
            topTippers = llListReplaceList(topTippers, [oldAmount + amount], i + 1, i +1);
            found = TRUE;
            break;
        }
    }

    if (!found)
    {
        topTippers += [name, amount];
        uniqueTippers++;
    }

    integer n = llGetListLength(topTippers) / 2;
    integer swapped;
    do
    {
        swapped = FALSE;
        for (i = 0; i < (n - 1) * 2; i += 2)
        {
            if (llList2Integer(topTippers, i + 1) < llList2Integer(topTippers, i + 3))
            {
                list temp = llList2List(topTippers, i, i + 1);
                topTippers = llListReplaceList(topTippers, llList2List(topTippers, i + 2, i + 3), i, i + 1);
                topTippers = llListReplaceList(topTippers, temp, i + 2, i + 3);
                swapped = TRUE;
            }
        }
    } while (swapped);

    if (llGetListLength(topTippers) > 20)
    {
        topTippers = llList2List(topTippers, 0, 19);
    }
}

updateDisplay()
{
    string displayText = "Dev's Tip Jar :3\nL$" + (string)totalTipped + " tipped";

    if (goalEnabled && goalAmount > 0)
    {
        float progress = ((float)totalTipped / (float)goalAmount) * 100.0;
        if (progress > 100.0) progress = 100.0;
        displayText += "\nGoal: " + (string)((integer)progress) + "% of L$" + (string)goalAmount;
    }

    displayText += "\n\nTop Tippers:";
    integer i;
    integer showCount = llGetListLength(topTippers) / 2;
    if (showCount > 5) showCount = 5;

    for (i = 0; i < showCount * 2; i += 2)
    {
        string tipperName = llList2String(topTippers, i);
        integer tipperAmount = llList2Integer(topTippers, i + 1);
        displayText += "\n" + (string)((i/2) + 1) + ". " + tipperName + " - L$" + (string)tipperAmount;
    }

    vector textColor = <1, 1, 1>;
    if (goalEnabled && totalTipped >= goalAmount)
        textColor = <0, 1, 0>;

    llSetText(displayText, textColor, 1.0);
}

sendStatsToOwner()
{
    string stats = "\nTIP JAR STATISTICS\n";
    stats += "Total Tipped: L$" + (string)totalTipped + "\n";
    stats += "Total Tips: " + (string)tipCount + "\n";
    stats += "Unique Tippers: " + (string)uniqueTippers + "\n";
    stats += "Average Tip: L$" + (string)((integer)averageTip) + "\n\n";
    stats += "LEADERBOARD:\n";

    integer i;
    for (i = 0; i < llGetListLength(topTippers) && i < 20; i += 2)
    {
        stats += (string)((i/2) + 1) + ". " + llList2String(topTippers, i);
        stats += " - L$" + (string)llList2Integer(topTippers, i + 1) + "\n";
    }

    llOwnerSay(stats);
}

default
{
    state_entry()
    {
        LISTEN_CHANNEL = -1 - (integer)llFrand(999999);
        listenHandle = llListen(LISTEN_CHANNEL, "", "", "");
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);

        string desc = llGetObjectDesc();
        if (desc != "")
        {
            list data = llParseString2List(desc, ["|"], []);
            if (llGetListLength(data) >= 1)
                totalTipped = llList2Integer(data, 0);
        }   

        updateDisplay();
        llSay(0, "tip jar ready! touch to contribute :3");
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_DEBIT)
        {
            llOwnerSay("tip jar permissions granted. ready to accept tips! :3");
        }
    }

    touch_start(integer num_detected)
    {
        key toucher = llDetectedKey(0);

        if (toucher == llGetOwner())
        {
            sendStatsToOwner();
            llDialog(toucher, "Owner Menu:", ["Stats", "Reset", "Set Goal", "Toggle Goal", "Test Tip"], LISTEN_CHANNEL);
            return;
        }

        llDialog(toucher, "How would you like to tip?", ["Quick L$10", "Quick L$50", "Quick L$100", "Custom"], LISTEN_CHANNEL);
    }

    listen(integer channel, string name, key id, string message)
    {
        if (channel != LISTEN_CHANNEL) return;

        if (id == llGetOwner())
        {
            if (message == "Stats")
            {
                sendStatsToOwner();
            }
            else if (message == "Reset")
            {
                totalTipped = 0;
                tipCount = 0;
                uniqueTippers = 0;
                averageTip = 0.0;
                topTippers = [];
                llSetObjectDesc("");
                updateDisplay();
                llOwnerSay("Tip jar statistics reset");
            }
            else if (message == "Set Goal")
            {
                llTextBox(id, "Enter new goal amount in (L$):", LISTEN_CHANNEL);
            }
            else if (message == "Toggle Goal")
            {
                goalEnabled = !goalEnabled;
                updateDisplay();
                if (goalEnabled)
                {
                llOwnerSay("Goal display enabled");
                }
                else
                {
                    llOwnerSay("Goal display disabled");
                }
            }
            else if (message == "Test Tip")
            {
                llDialog(id, "Test tip (as owner):", ["L$10", "L$50", "L$100"], LISTEN_CHANNEL);
            }
            else if ((integer)message > 0)
            {
                goalAmount = (integer)message;
                goalEnabled = TRUE;
                updateDisplay();
                llOwnerSay("Goal set to L$" + (string)goalAmount);
            }
            return;
        }

        integer tipAmount = 0;

        if (message == "Quick L$10")
            tipAmount = 10;
        else if (message == "Quick L$50")
            tipAmount = 50;
        else if (message == "Quick L$100")
            tipAmount = 100;
        else if (message == "Custom")
        {
            llTextBox(id, "Enter tip amount (L$):", LISTEN_CHANNEL);
            return;
        }
        else
        {
            tipAmount = (integer)message;
        }

        if (tipAmount <= 0)
        {
            llRegionSayTo(id, 0, "invalid tip amount .-. please try again");
            return;
        }

        llGiveMoney(llGetOwner(), tipAmount);
        totalTipped += tipAmount;
        tipCount++;
        averageTip = (float)totalTipped / (float)tipCount;

        string tipperName = llKey2Name(id);
        updateLeaderboard(tipperName, tipAmount);
        llSetObjectDesc((string)totalTipped);
        showParticles(tipAmount);
        updateDisplay();

        llRegionSayTo(id, 0, "thank you for your generous tip of L$" + (string)tipAmount + "!!!! ><");

        if (tipAmount >= 100)
        {
            llSay(0, tipperName + " just tipped L$" + (string)tipAmount + "!!! thank you !!! :3");
        }

        if (goalEnabled && totalTipped >= goalAmount)
        {
            llSay(0, "GOAL REACHED!! THANK YOU EVERYONE!!");
        }
    }

    timer()
    {
        llParticleSystem([]);
        llSetTimerEvent(0.0);
    }

    money(key giver, integer amount)
    {
        totalTipped += amount;
        tipCount++;
        averageTip = (float)totalTipped / (float)tipCount;

        string tipperName = llKey2Name(giver);
        updateLeaderboard(tipperName, amount);
        llSetObjectDesc((string)totalTipped);
        showParticles(amount);
        updateDisplay();

        llRegionSayTo(giver, 0, "thank you for your tip of L$ " + (string)amount + "!!!! ><");

        if (amount >= 100)
        {
            llSay(0, tipperName + " just tipped L$ " + (string)amount + "! thank you!! :3");
        }
    }
}