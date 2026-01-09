integer listenHandle;
integer totalTipped = 0;

default
{
    state_entry()
    {
        listenHandle = llListen(-1, "", "", "");
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        llSetText("💰 Tip Jar\nL$0 tipped", <1,  1, 1>, 1.0);
        llSay(0, "tip jar is ready! touch me to tip :3");
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_DEBIT)
        {
            llOwnerSay("✅ tip jar has permission to handle money!");
        }
        else
        {
            llOwnerSay("❌ error: no money permission granted. tip jar won't work!");
        }
    }

    touch_start(integer num_detected)
    {
        key toucher = llDetectedKey(0);
        llDialog(toucher, "How much would you like to tip?", ["L$10", "L$25", "L$50", "L$100"], -1);
    }

    listen(integer channel, string name, key id, string message)
    {
        string amountText = llGetSubString(message, 2, -1);
        integer tipAmount = (integer)amountText;

        if (tipAmount <= 0)
        {
            llRegionSayTo(id, 0, "invalid tip amount!");
            return;
        }

        llGiveMoney(llGetOwner(), tipAmount);
        totalTipped += tipAmount;

        llSetText("💰Tip Jar\nL$" + (string)totalTipped + " tipped", <0, 1, 0>, 1.0);
        llRegionSayTo(id, 0, "thank you for your L$" + (string)tipAmount + " tip !!! >< 🤍");

        if (tipAmount >= 100)
        {
            llSay(0, "🎉 " + llKey2Name(id) + " just tipped L$" + (string)tipAmount + "!");
        }
    }

    money (key giver, integer amount)
    {
        totalTipped += amount;
        llSetText("💰Tip Jar\nL$" + (string)totalTipped + " tipped",  <0, 1, 0>, 1.0);
        llRegionSayTo(giver, 0, "thank you for your L$" + (string)amount + " tip !!! >< 🤍");

        if (amount >= 100)
        {
            llSay(0, "🎉 " + llKey2Name(giver) + " just tipped L$" + (string)amount + "!");
        }
    }
}
