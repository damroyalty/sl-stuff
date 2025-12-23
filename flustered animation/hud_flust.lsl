// animation name must exist in inventory
string ANIM_NAME = "dev_flushed (add)";

string TEXTURE_UUID = "d26597b9-0541-7efd-fbd7-150d6e6fc1cc";
integer FACE = -1; // face index to apply the texture (-1 applies to all faces)

vector IDLE_SIZE = <0.25, 0.25, 0.05>;
float POP_DURATION = 0.18;
float FADE_DURATION = 0.18;
float ANIM_DURATION = 2.0;

integer busy = FALSE;
integer hasAnimPerm = FALSE;
key dialogTarget = NULL_KEY;
integer dialogListen = 0;
integer textListen = 0;
float DIALOG_TIMEOUT = 12.0;

float easeOut(float t)
{
    t = t - 1.0;
    return t * t * t + 1.0;
}

default
{
    state_entry()
    {
        integer attached = llGetAttached();
        llSetClickAction(CLICK_ACTION_TOUCH);
        if (TEXTURE_UUID != "") llSetTexture(TEXTURE_UUID, FACE);

        if (attached == 0)
        {
            llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, IDLE_SIZE]);
            llSetAlpha(1.0, FACE);
        }
        else
        {
            llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, <0.001,0.001,0.001>]);
            llSetAlpha(0.0, FACE);
        }
    }

    attach(key id)
    {
        if (id == NULL_KEY)
        {
            hasAnimPerm = FALSE;
            return;
        }

        integer steps = 10;
        integer i;
        for (i = 1; i <= steps; ++i)
        {
            float t = (float)i / (float)steps;
            float e = easeOut(t);
            vector s = IDLE_SIZE * (0.2 + 0.8 * e);
            llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, s]);
            float a = t;
            llSetAlpha(a, FACE);
            llSleep(POP_DURATION / (float)steps);
        }

        llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, IDLE_SIZE]);
        llSetAlpha(1.0, FACE);

        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }

    listen(integer channel, string name, key id, string message)
    {
        if (channel == 0 && id == dialogTarget)
        {
            if (message == "Play")
            {
                if (!hasAnimPerm)
                {
                    llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
                    llOwnerSay("Please grant 'Trigger animation' permission and then press Play again.");
                }
                else
                {
                    if (!busy)
                    {
                        busy = TRUE;
                        llOwnerSay("Attempting to play animation: " + ANIM_NAME);
                        llStartAnimation(ANIM_NAME);
                        vector bigger = IDLE_SIZE * 1.35;
                        llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, bigger]);
                        llSetText("Playing...", <1,1,1>, 1.0);
                        llSleep(0.14);
                        llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, IDLE_SIZE]);
                        llSetText("", <0,0,0>, 0.0);
                        llSetTimerEvent(ANIM_DURATION);
                    }
                }
            }
            else if (message == "Set Anim")
            {
                // prompt owner to type the animation name on a private channel
                llOwnerSay("Type the new animation name in local chat on channel 7777: '/7777 The Animation Name'");
                textListen = llListen(7777, "", llGetOwner(), "");
            }
            else
            {
            }
            if (dialogListen)
            {
                llListenRemove(dialogListen);
                dialogListen = 0;
            }
            dialogTarget = NULL_KEY;
            return;
        }

        // owner typing new ani on channel 7777
        if (channel == 7777 && id == llGetOwner())
        {
            string newName = llStringTrim(message, STRING_TRIM);
            if (llStringLength(newName) > 0)
            {
                ANIM_NAME = newName;
                llOwnerSay("Animation name set to: " + ANIM_NAME + ". Now touch or use Play from the HUD menu to test.");
            }
            else
            {
                llOwnerSay("Empty name — animation not changed.");
            }

            if (textListen)
            {
                llListenRemove(textListen);
                textListen = 0;
            }
            return;
        }
    }

    touch_start(integer total_number)
    {
        if (busy) return;

        if (!hasAnimPerm)
        {
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
            llOwnerSay("Please grant 'Trigger animation' permission to this HUD (Allow/Yes when prompted).");
            return;
        }

        busy = TRUE;
        llOwnerSay("Attempting to play animation: " + ANIM_NAME + " — ensure it is in your Inventory → Animations");
        llStartAnimation(ANIM_NAME);

        vector bigger = IDLE_SIZE * 1.35;
        llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, bigger]);
        llSetText("Playing...", <1,1,1>, 1.0);
        llSleep(0.14);
        llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, IDLE_SIZE]);
        llSetText("", <0,0,0>, 0.0);

        llSetTimerEvent(ANIM_DURATION);
    }

    timer()
    {
        if (hasAnimPerm) llStopAnimation(ANIM_NAME);
        busy = FALSE;
        llSetTimerEvent(0.0);
    }

    run_time_permissions(integer perms)
    {
        if (perms & PERMISSION_TRIGGER_ANIMATION)
        {
            hasAnimPerm = TRUE;
            llOwnerSay("Animation permission granted — touch the HUD to play the animation.");
        }
        else
        {
            hasAnimPerm = FALSE;
            llOwnerSay("Animation permission NOT granted. Re-attach and allow 'Trigger animation' to enable the HUD.");
        }
    }
}
