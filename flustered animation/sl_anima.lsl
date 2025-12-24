doFlushedEffect(key toucherID)
{ 
    if (!heartbeatActive)
    {
        llLoopSound("0077531d-fa99-088b-3c43-dfdf935349ef", 0.9);
        heartbeatActive = TRUE;
    }
    else
    {
    }
    heartbeatEnd = llGetTime() + 3.0;
    llSetTimerEvent(0.3);
    
    string origName = llGetObjectName();
    key ownerID = llGetOwner();
    
    string ownerName = llKey2Name(ownerID);
    ownerName = llList2String(llParseString2List(ownerName, [" "], []), 0);
    
    string toucherName = llKey2Name(toucherID);
    toucherName = llList2String(llParseString2List(toucherName, [" "], []), 0);
    
    llSetObjectName(ownerName);
    
    if (toucherID == ownerID)
    {
        llSay(0, "/me is totally flustered 😳💕");
    }
    else
    {
        llSay(0, "/me is totally flustered by " + toucherName + " 😳💕");
    }
    
    llSetObjectName(origName);
    
    llParticleSystem([]);  
    llParticleSystem([
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_BURST_PART_COUNT, 25,
        PSYS_SRC_BURST_RATE, 0.3,
        PSYS_PART_MAX_AGE, 4.0,
        PSYS_SRC_ACCEL, (vector)<0, 0, 0.15>,
        PSYS_SRC_TEXTURE, "blush-emoji",
        
        PSYS_SRC_BURST_SPEED_MIN, (float)0.05,
        PSYS_SRC_BURST_SPEED_MAX, (float)0.15,
        PSYS_PART_START_SCALE, (vector)<0.12, 0.12, 0>,
        PSYS_PART_END_SCALE, (vector)<0.05, 0.05, 0>,
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

string FLUSHER_ID = "";
string LAST_TOUCHER = "";
float LAST_TOUCHER_TIME = 0.0;
float LAST_TOUCHER_TTL = 30.0;

string LAST_TOKEN = "";
float LAST_TOKEN_TIME = 0.0;
float LAST_TOKEN_TTL = 30.0;

integer heartbeatActive = FALSE;
float heartbeatEnd = 0.0;

default
{
    state_entry()
    {
        llPreloadSound("0077531d-fa99-088b-3c43-dfdf935349ef");
        llPreloadSound("dd65e655-fcf3-8000-471f-930ef9f4a4d8");
        llListen(999, "", NULL_KEY, "");
        FLUSHER_ID = (string)llGetKey();
        llRegionSay(999, "I_AM_FLUSHER:" + FLUSHER_ID);
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
            LAST_TOUCHER = (string)toucherID;
            LAST_TOUCHER_TIME = llGetTime();
            LAST_TOKEN = (string)(llGetTime()) + ":" + (string)llFrand(1000000.0);
            LAST_TOKEN_TIME = llGetTime();
            doFlushedEffect(toucherID);
            llRegionSay(999, "I_AM_FLUSHER_FOR:" + (string)toucherID + ":" + FLUSHER_ID + ":" + LAST_TOKEN);
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "FLUSHED" && id == llGetOwner())
        {
            doFlushedEffect(llGetOwner());
            return;
        }
        string tokenPrefix = "FLUSHED_TOKEN:";
        if (llSubStringIndex(message, tokenPrefix) == 0)
        {
            integer len = llStringLength(message);
            string payload = llGetSubString(message, llStringLength(tokenPrefix), len - 1);
            list parts = llParseString2List(payload, [":"], []);
            if (llGetListLength(parts) >= 3)
            {
                string avatarKey = llList2String(parts, 0);
                string flusherKey = llList2String(parts, 1);
                string token = llList2String(parts, 2);
                if (flusherKey == FLUSHER_ID && token == LAST_TOKEN && llGetTime() <= LAST_TOKEN_TIME + LAST_TOKEN_TTL && avatarKey == LAST_TOUCHER)
                {
                    doFlushedEffect((key)avatarKey);
                }
            }
            return;
        }

        string prefix = "FLUSHED:";
        if (llSubStringIndex(message, prefix) == 0)
        {
            integer len = llStringLength(message);
            string payload = llGetSubString(message, llStringLength(prefix), len - 1);

            integer sep = llSubStringIndex(payload, ":");
            if (sep != -1)
            {
                string avatarKey = llGetSubString(payload, 0, sep - 1);
                string flusherKey = llGetSubString(payload, sep + 1, llStringLength(payload) - 1);
                if (flusherKey == FLUSHER_ID)
                {
                    if (avatarKey == LAST_TOUCHER && llGetTime() <= LAST_TOUCHER_TIME + LAST_TOUCHER_TTL)
                    {
                        doFlushedEffect((key)avatarKey);
                    }
                }
            }
            else
            {
                if (payload == (string)llGetOwner())
                {
                    doFlushedEffect(llGetOwner());
                }
            }
        }
    }

    timer()
    {
        if (!heartbeatActive) { llSetTimerEvent(0.0); return; }
        if (llGetTime() >= heartbeatEnd)
        {
            llStopSound();
            heartbeatActive = FALSE;
            heartbeatEnd = 0.0;
            llSetTimerEvent(0.0);
        }
    }
}