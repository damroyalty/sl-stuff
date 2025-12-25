string DISPLAY_NAME = "";  // will be set to the owner's name at runtime

string SOUND_FLUSHED = "0077531d-fa99-088b-3c43-dfdf935349ef"; // heartbeat
string SOUND_MINDBLOWN = "421e0587-4bf3-d156-0f0c-42fcd68801f1";    // explosion sound
string SOUND_HEARTEYES = "0077531d-fa99-088b-3c43-dfdf935349ef";    // romantic sound
string SOUND_SWEATDROP = "dd65e655-fcf3-8000-471f-930ef9f4a4d8";    // drop sound
string SOUND_NERVOUS = "0077531d-fa99-088b-3c43-dfdf935349ef";      // shaking/anxious sound
string SOUND_STARRY = "dd65e655-fcf3-8000-471f-930ef9f4a4d8"; // chime

string TEX_FLUSHED = "blush-emoji";
string TEX_MINDBLOWN = "explosion-emoji";
string TEX_HEARTEYES = "heart-eyes-emoji";
string TEX_SWEATDROP = "sweatdrop-emoji";
string TEX_NERVOUS = "nervous-emoji";
string TEX_STARRY = "star-emoji";

integer heartbeat_active = FALSE;
integer mindblown_active = FALSE;

doFlushed(key toucherID)
{
    llSleep(0.3);
    llPlaySound(SOUND_FLUSHED, 0.9);
    heartbeat_active = TRUE;
    llSetTimerEvent(3.0);
    
    string origName = llGetObjectName();
    string ownerName = DISPLAY_NAME;
    string toucherName = llKey2Name(toucherID);
    toucherName = llList2String(llParseString2List(toucherName, [" "], []), 0);
    
    llSetObjectName(ownerName);
    if (toucherID == llGetOwner())
    {
        llSay(0, "/me is totally flustered 😳 💕");
    }
    else
    {
        llSay(0, "/me is totally flustered by " + toucherName + " 😳 💕");
    }
    llSetObjectName(origName);
    
    llParticleSystem([]);
    llParticleSystem([
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_BURST_PART_COUNT, 15,
        PSYS_SRC_BURST_RATE, 0.2,
        PSYS_PART_MAX_AGE, 3.0,
        PSYS_SRC_ACCEL, (vector)<0, 0, 0.15>,
        PSYS_SRC_TEXTURE, TEX_FLUSHED,
        PSYS_SRC_BURST_SPEED_MIN, (float)0.05,
        PSYS_SRC_BURST_SPEED_MAX, (float)0.15,
        PSYS_PART_START_SCALE, (vector)<0.12, 0.12, 0>,
        PSYS_PART_END_SCALE, (vector)<0.05, 0.05, 0>,
        PSYS_PART_START_COLOR, (vector)<1.0, 0.6, 0.75>,
        PSYS_PART_END_COLOR, (vector)<1.0, 0.8, 0.9>,
        PSYS_PART_START_ALPHA, 0.9,
        PSYS_PART_END_ALPHA, 0.0,
        PSYS_SRC_MAX_AGE, (float)1.0,
        PSYS_PART_FLAGS,
            PSYS_PART_EMISSIVE_MASK |
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_INTERP_SCALE_MASK |
            0
    ]);
}

doMindBlown()
{
    if (SOUND_MINDBLOWN != "")
    {
        llPlaySound(SOUND_MINDBLOWN, 0.8);
        mindblown_active = TRUE;
        llSetTimerEvent(2.5);
    }
    
    string origName = llGetObjectName();
    llSetObjectName(DISPLAY_NAME);
    llSay(0, "/me's mind is BLOWN 🤯✨");
    llSetObjectName(origName);
    
    llParticleSystem([]);
    llParticleSystem([
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_BURST_PART_COUNT, 30,
        PSYS_SRC_BURST_RATE, 0.1,
        PSYS_PART_MAX_AGE, 2.0,
        PSYS_SRC_ACCEL, (vector)<0, 0, 0.5>,
        PSYS_SRC_BURST_RADIUS, (float)0.12,
        PSYS_SRC_TEXTURE, TEX_MINDBLOWN,
        PSYS_SRC_BURST_SPEED_MIN, (float)0.18,
        PSYS_SRC_BURST_SPEED_MAX, (float)0.5,
        PSYS_PART_START_SCALE, (vector)<0.17, 0.17, 0>,
        PSYS_PART_END_SCALE, (vector)<0.08, 0.08, 0>,
        PSYS_PART_START_COLOR, (vector)<1.0, 0.8, 0.0>,
        PSYS_PART_END_COLOR, (vector)<1.0, 0.4, 0.0>,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.0,
        PSYS_SRC_MAX_AGE, (float)0.8,
        PSYS_PART_FLAGS,
            PSYS_PART_EMISSIVE_MASK |
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_INTERP_SCALE_MASK |
            0
    ]);
}

doHeartEyes()
{
    if (SOUND_HEARTEYES != "") llPlaySound(SOUND_HEARTEYES, 0.7);
    
    string origName = llGetObjectName();
    llSetObjectName(DISPLAY_NAME);
    llSay(0, "/me has HEART EYES 😍💕");
    llSetObjectName(origName);
    
    llParticleSystem([]);
    llParticleSystem([
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
        PSYS_SRC_BURST_PART_COUNT, 8,
        PSYS_SRC_BURST_RATE, 0.12,
        PSYS_PART_MAX_AGE, 3.0,
        PSYS_SRC_ACCEL, (vector)<0.6, 0.0, -0.06>,
        PSYS_SRC_TEXTURE, TEX_HEARTEYES,
        PSYS_SRC_BURST_SPEED_MIN, (float)0.12,
        PSYS_SRC_BURST_SPEED_MAX, (float)0.30,
        PSYS_SRC_BURST_RADIUS, (float)0.10,
        PSYS_SRC_ANGLE_BEGIN, (float)0.0,
        PSYS_SRC_ANGLE_END, (float)0.45,
        PSYS_PART_START_SCALE, (vector)<0.10, 0.10, 0>,
        PSYS_PART_END_SCALE, (vector)<0.05, 0.05, 0>,
        PSYS_PART_START_COLOR, (vector)<1.0, 0.2, 0.4>,
        PSYS_PART_END_COLOR, (vector)<1.0, 0.6, 0.7>,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.0,
        PSYS_SRC_MAX_AGE, (float)2.0,
        PSYS_PART_FLAGS,
            PSYS_PART_EMISSIVE_MASK |
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_INTERP_SCALE_MASK |
            0
    ]);
}

doAwkward()
{
    if (SOUND_SWEATDROP != "") llPlaySound(SOUND_SWEATDROP, 0.6);
    
    string origName = llGetObjectName();
    llSetObjectName(DISPLAY_NAME);
    llSay(0, "/me feels SO awkward right now💧");
    llSetObjectName(origName);
    
    llParticleSystem([]);
    llParticleSystem([
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_BURST_PART_COUNT, 18,
        PSYS_SRC_BURST_RATE, 0.12,
        PSYS_PART_MAX_AGE, 2.4,
        PSYS_SRC_ACCEL, (vector)<0, 0, -0.9>,
        PSYS_SRC_TEXTURE, TEX_SWEATDROP,
        PSYS_SRC_BURST_SPEED_MIN, (float)0.25,
        PSYS_SRC_BURST_SPEED_MAX, (float)0.6,
        PSYS_SRC_BURST_RADIUS, (float)0.18,
        PSYS_PART_START_SCALE, (vector)<0.09, 0.09, 0>,
        PSYS_PART_END_SCALE, (vector)<0.04, 0.04, 0>,
        PSYS_PART_START_COLOR, (vector)<0.6, 0.8, 1.0>,
        PSYS_PART_END_COLOR, (vector)<0.4, 0.7, 1.0>,
        PSYS_PART_START_ALPHA, 0.95,
        PSYS_PART_END_ALPHA, 0.0,
        PSYS_SRC_MAX_AGE, (float)1.4,
        PSYS_PART_FLAGS,
            PSYS_PART_EMISSIVE_MASK |
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_INTERP_SCALE_MASK |
            0
    ]);
}

doNervous()
{
    if (SOUND_NERVOUS != "") llPlaySound(SOUND_NERVOUS, 0.7);
    
    string origName = llGetObjectName();
    llSetObjectName(DISPLAY_NAME);
    llSay(0, "/me is having MAJOR anxiety 😰💦");
    llSetObjectName(origName);
    
    llParticleSystem([]);
    llParticleSystem([
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_BURST_PART_COUNT, 22,
        PSYS_SRC_BURST_RATE, 0.12,
        PSYS_PART_MAX_AGE, 2.4,
        PSYS_SRC_ACCEL, (vector)<0, 0, -0.9>,
        PSYS_SRC_TEXTURE, TEX_NERVOUS,
        PSYS_SRC_BURST_SPEED_MIN, (float)0.25,
        PSYS_SRC_BURST_SPEED_MAX, (float)0.6,
        PSYS_SRC_BURST_RADIUS, (float)0.18,
        PSYS_PART_START_SCALE, (vector)<0.10, 0.10, 0>,
        PSYS_PART_END_SCALE, (vector)<0.06, 0.06, 0>,
        PSYS_PART_START_COLOR, (vector)<0.5, 0.5, 0.7>,
        PSYS_PART_END_COLOR, (vector)<0.6, 0.6, 0.8>,
        PSYS_PART_START_ALPHA, 0.9,
        PSYS_PART_END_ALPHA, 0.0,
        PSYS_SRC_MAX_AGE, (float)1.4,
        PSYS_PART_FLAGS,
            PSYS_PART_EMISSIVE_MASK |
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_INTERP_SCALE_MASK |
            0
    ]);
}

doStarry()
{
    if (SOUND_STARRY != "") llPlaySound(SOUND_STARRY, 0.8);
    
    string origName = llGetObjectName();
    llSetObjectName(DISPLAY_NAME);
    llSay(0, "/me is STARSTRUCK ✨⭐");
    llSetObjectName(origName);
    
    llParticleSystem([]);
    llParticleSystem([
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_BURST_PART_COUNT, 12,
        PSYS_SRC_BURST_RATE, 0.25,
        PSYS_PART_MAX_AGE, 3.5,
        PSYS_SRC_ACCEL, (vector)<0, 0, 0.12>,
        PSYS_SRC_TEXTURE, TEX_STARRY,
        PSYS_SRC_BURST_SPEED_MIN, (float)0.03,
        PSYS_SRC_BURST_SPEED_MAX, (float)0.10,
        PSYS_PART_START_SCALE, (vector)<0.12, 0.12, 0>,
        PSYS_PART_END_SCALE, (vector)<0.04, 0.04, 0>,
        PSYS_PART_START_COLOR, (vector)<1.0, 1.0, 0.6>,
        PSYS_PART_END_COLOR, (vector)<1.0, 1.0, 0.9>,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.0,
        PSYS_SRC_MAX_AGE, (float)1.5,
        PSYS_PART_FLAGS,
            PSYS_PART_EMISSIVE_MASK |
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_INTERP_SCALE_MASK |
            0
    ]);
}

// main :3

default
{
    state_entry()
    {
        key owner_id = llGetOwner();
        string full = llKey2Name(owner_id);
        DISPLAY_NAME = llList2String(llParseString2List(full, [" "], []), 0);

        if (SOUND_FLUSHED != "") llPreloadSound(SOUND_FLUSHED);
        if (SOUND_MINDBLOWN != "") llPreloadSound(SOUND_MINDBLOWN);
        if (SOUND_HEARTEYES != "") llPreloadSound(SOUND_HEARTEYES);
        if (SOUND_SWEATDROP != "") llPreloadSound(SOUND_SWEATDROP);
        if (SOUND_NERVOUS != "") llPreloadSound(SOUND_NERVOUS);
        if (SOUND_STARRY != "") llPreloadSound(SOUND_STARRY);
        
        llListen(999, "", NULL_KEY, "");
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    touch_start(integer total_number)
    {
        integer i;
        for (i = 0; i < total_number; i += 1)
        {
            key toucherID = llDetectedKey(i);
            doFlushed(toucherID);
        }
    }

    timer()
    {
        if (heartbeat_active || mindblown_active)
        {
            llStopSound();
            heartbeat_active = FALSE;
            mindblown_active = FALSE;
            llSetTimerEvent(0.0);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (llSubStringIndex(message, "EMOTION:") == 0)
        {
            list parts = llParseString2List(message, [":"], []);
            string emotion = llList2String(parts, 1);
            string ownerKey = llList2String(parts, 2);
            
            if ((key)ownerKey == llGetOwner())
            {
                if (emotion == "FLUSHED")
                {
                    doFlushed(llGetOwner());
                }
                else if (emotion == "MINDBLOWN")
                {
                    doMindBlown();
                }
                else if (emotion == "HEARTEYES")
                {
                    doHeartEyes();
                }
                else if (emotion == "SWEATDROP")
                {
                    doAwkward();
                }
                else if (emotion == "NERVOUS")
                {
                    doNervous();
                }
                else if (emotion == "STARRY")
                {
                    doStarry();
                }
            }
        }
    }
}