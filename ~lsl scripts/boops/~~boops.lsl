string SOUND_BOOP = "";
string TEX_BOOP = "boop-particle";

doBoop(key booperID)
{
    if (SOUND_BOOP != "") llPlaySound(SOUND_BOOP, 0.7);

    key ownerID = llGetOwner();

    string ownerName = llKey2Name(ownerID);
    ownerName = llList2String(llParseString2List(ownerName, [" "], []), 0);

    string booperName = llKey2Name(booperID);
    booperName = llList2String(llParseString2List(booperName, [" "], []), 0);

    string origName = llGetObjectName();
    llSetObjectName(ownerName);

    if (booperID == ownerID)
    {
        llSay(0, "/me booped themselves!");
    }
    else
    {
        llSay(0, "/me got booped by " + booperName + "!✨");
    }

    llSetObjectName(origName);

    llParticleSystem([]);
    llParticleSystem([
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_BURST_PART_COUNT, 8,
        PSYS_SRC_BURST_RATE, 0.1,
        PSYS_PART_MAX_AGE, 1.0,
        PSYS_SRC_ACCEL, (vector)<0, 0, 0>,
        PSYS_SRC_TEXTURE, TEX_BOOP,
        PSYS_SRC_BURST_SPEED_MIN, (float)0.1,
        PSYS_SRC_BURST_SPEED_MAX, (float)0.3,
        PSYS_PART_START_SCALE, (vector)<0.08, 0.08, 0>,
        PSYS_PART_END_SCALE, (vector)<0.02, 0.02, 0>,
        PSYS_PART_START_COLOR, (vector)<1.0, 0.8, 0.3>,
        PSYS_PART_END_COLOR, (vector)<1.0, 1.0, 0.8>,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.0,
        PSYS_SRC_MAX_AGE, (float)0.3,
        PSYS_PART_FLAGS,
            PSYS_PART_EMISSIVE_MASK |
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_INTERP_SCALE_MASK |
            0
    ]);
}

default
{
    state_entry()
    {
        if (SOUND_BOOP != "") llPreloadSound(SOUND_BOOP);
        llListen(999, "", NULL_KEY, "");
        llOwnerSay("boop button ready! touch to boop!");
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
            key booperID = llDetectedKey(i);
            doBoop(booperID);
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "BOOP" && llSubStringIndex((string)id, (string)llGetOwner()) != -1)
        {
            doBoop(llGetOwner());
        }
    }
}