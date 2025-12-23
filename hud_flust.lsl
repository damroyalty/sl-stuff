// hud_button_simple.lsl
// Enhanced single-button HUD: smooth pop/fade, texture auto-apply,
// and plays a named avatar animation on touch. Configure values below.

// Avatar animation name (must exist in the avatar's inventory)
string ANIM_NAME = "Flushed";

// Optional texture UUID (paste the texture's UUID string here). Leave empty to set texture manually.
string TEXTURE_UUID = "d26597b9-0541-7efd-fbd7-150d6e6fc1cc";
integer FACE = -1; // face index to apply the texture (-1 applies to all faces)

// Visual tuning
vector IDLE_SIZE = <0.25, 0.25, 0.05>; // final HUD prim size (meters)
float POP_DURATION = 0.18; // time for the pop-in effect (seconds)
float FADE_DURATION = 0.18; // time to fade alpha from 0 to 1
float ANIM_DURATION = 2.0; // how long to let the animation play

integer busy = FALSE;
integer hasAnimPerm = FALSE;
key dialogTarget = NULL_KEY;
integer dialogListen = 0;
integer textListen = 0;
float DIALOG_TIMEOUT = 12.0;

// Easing helper (simple cubic ease-out)
float easeOut(float t)
{
    t = t - 1.0;
    return t * t * t + 1.0;
}

default
{
    state_entry()
    {
        // If not attached, show the prim at normal size so you can preview it while rezzed.
        // If attached, start tiny and transparent so attach() performs the pop-in.
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
            // Permission is revoked on detach
            hasAnimPerm = FALSE;
            return; // detached
        }

        integer steps = 10;
        integer i;
        for (i = 1; i <= steps; ++i)
        {
            float t = (float)i / (float)steps;
            float e = easeOut(t);
            vector s = IDLE_SIZE * (0.2 + 0.8 * e);
            llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, s]);
            float a = t; // linear alpha ramp (simple)
            llSetAlpha(a, FACE);
            llSleep(POP_DURATION / (float)steps);
        }

        // Ensure final values
        llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, IDLE_SIZE]);
        llSetAlpha(1.0, FACE);

        // Request permission to trigger animations on the avatar
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }

    listen(integer channel, string name, key id, string message)
    {
        // Dialog response from owner
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
                    // Play animation (owner invoked)
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
                // Prompt owner to type the animation name on a private channel
                llOwnerSay("Type the new animation name in local chat on channel 7777: '/7777 The Animation Name'");
                textListen = llListen(7777, "", llGetOwner(), "");
            }
            else // Cancel or unknown
            {
                // No-op
            }

            // remove the dialog listen and clear target
            if (dialogListen)
            {
                llListenRemove(dialogListen);
                dialogListen = 0;
            }
            dialogTarget = NULL_KEY;
            return;
        }

        // Owner typed the new animation name on channel 7777
        if (channel == 7777 && id == llGetOwner())
        {
            // Trim whitespace (simple)
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
        if (busy) return; // ignore while animating

        if (!hasAnimPerm)
        {
            // If we don't have permission yet, request it and notify the user
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
            llOwnerSay("Please grant 'Trigger animation' permission to this HUD (Allow/Yes when prompted).");
            return;
        }

        busy = TRUE;

        // Notify owner and start avatar animation (must exist in avatar inventory)
        llOwnerSay("Attempting to play animation: " + ANIM_NAME + " — ensure it is in your Inventory → Animations");
        llStartAnimation(ANIM_NAME);

        // Visual feedback: quick scale pulse + subtle glow with llSetText
        vector bigger = IDLE_SIZE * 1.35;
        llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, bigger]);
        llSetText("Playing...", <1,1,1>, 1.0);
        llSleep(0.14);
        llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_SIZE, IDLE_SIZE]);
        llSetText("", <0,0,0>, 0.0);

        // Schedule stopping the animation
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
