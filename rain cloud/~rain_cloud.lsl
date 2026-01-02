string SOUND_RAIN = "";  // add rain drop sounds eventually, also want to add lightening setting eventually

string TEX_RAINDROP = "raindrop";  // just in case
string TEX_CLOUD = "cloud";  // upload cloud texture

// rain modes
integer rainMode = 0;  // 0 = off, 1 = light, 2 = heavy, 3 = storm

startRain(integer mode)
{
    rainMode = mode;
    
    if (mode == 0)
    {
        llParticleSystem([]);
        llStopSound();
        llOwnerSay("☀️ Rain stopped!");
        return;
    }
    
    integer burstCount;
    float burstRate;
    vector rainColor;
    string moodText;
    float spreadRadius;
    
    if (mode == 1)
    {
        burstCount = 15;
        burstRate = 0.2;
        rainColor = <0.7, 0.8, 1.0>;
        moodText = "light rain☁️💧";
        spreadRadius = 0.8;
    }
    else if (mode == 2)
    {
        burstCount = 30;
        burstRate = 0.1;
        rainColor = <0.5, 0.6, 0.8>;
        moodText = "heavy rain☁️🌧️";
        spreadRadius = 1.0;
    }
    else if (mode == 3)
    {
        burstCount = 50;
        burstRate = 0.05;
        rainColor = <0.3, 0.4, 0.6>;
        moodText = "stormy rain⛈️";
        spreadRadius = 1.2;
    }
    
    string ownerName = llGetDisplayName(llGetOwner());
    
    string origName = llGetObjectName();
    llSetObjectName(ownerName);
    llSay(0, "/me has a personal " + moodText);
    llSetObjectName(origName);
    
    if (SOUND_RAIN != "") llLoopSound(SOUND_RAIN, 0.3);
    
    llParticleSystem([]);
    llParticleSystem([
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_BURST_PART_COUNT, burstCount,
        PSYS_SRC_BURST_RATE, burstRate,
        PSYS_PART_MAX_AGE, 3.5,
        PSYS_SRC_ACCEL, <0, 0, -3.0>,
        PSYS_SRC_TEXTURE, TEX_RAINDROP,
        PSYS_SRC_BURST_SPEED_MIN, 0.01,
        PSYS_SRC_BURST_SPEED_MAX, 0.05,
        PSYS_SRC_BURST_RADIUS, spreadRadius,
        PSYS_PART_START_SCALE, <0.05, 0.15, 0>,
        PSYS_PART_END_SCALE, <0.03, 0.10, 0>,
        PSYS_PART_START_COLOR, rainColor,
        PSYS_PART_END_COLOR, rainColor,
        PSYS_PART_START_ALPHA, 0.8,
        PSYS_PART_END_ALPHA, 0.2,
        PSYS_SRC_MAX_AGE, 0.0,
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
        if (SOUND_RAIN != "") llPreloadSound(SOUND_RAIN);
        llListen(999, "", NULL_KEY, "");
        llOwnerSay("☁️ Rain Cloud Ready!");
        llOwnerSay("Touch to cycle: Off → Light → Heavy → Storm");
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            rainMode++;
            if (rainMode > 3) rainMode = 0;
            startRain(rainMode);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (llSubStringIndex(message, "RAIN:") == 0)
        {
            list parts = llParseString2List(message, [":"], []);
            string command = llList2String(parts, 1);
            
            if (command == "OFF") startRain(0);
            else if (command == "LIGHT") startRain(1);
            else if (command == "HEAVY") startRain(2);
            else if (command == "STORM") startRain(3);
        }
    }
}