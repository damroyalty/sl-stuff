vector FOG_COLOR = <0.8, 0.8, 0.9>;    // light gray-blue fog
float PARTICLE_SIZE_START = 6.0;       // starting size of fog particles
float PARTICLE_SIZE_END = 12.0;        // ending size (grows as it rises)
float PARTICLE_ALPHA_START = 0.2;      // starting transparency (0.0-1.0)
float PARTICLE_ALPHA_END = 0.0;        // ending transparency (fades out)
float EMIT_RATE = 0.15;                // particles per second (lower = less lag)
float PARTICLE_LIFE = 8.0;             // how long each particle lives (seconds)
float RISE_SPEED = 0.2;                // how fast fog drifts upward

integer CHANNEL = -98765;
integer fogEnabled = TRUE;
float currentAlpha = 0.2;
float currentRate = 0.15;

startFog()
{
    llParticleSystem([
        PSYS_PART_FLAGS, 
            PSYS_PART_EMISSIVE_MASK |
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_INTERP_SCALE_MASK,
        
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        
        PSYS_PART_START_COLOR, FOG_COLOR,
        PSYS_PART_END_COLOR, FOG_COLOR,
        PSYS_PART_START_ALPHA, currentAlpha,
        PSYS_PART_END_ALPHA, PARTICLE_ALPHA_END,
        
        PSYS_PART_START_SCALE, <PARTICLE_SIZE_START, PARTICLE_SIZE_START, 0.0>,
        PSYS_PART_END_SCALE, <PARTICLE_SIZE_END, PARTICLE_SIZE_END, 0.0>,
        
        PSYS_PART_MAX_AGE, PARTICLE_LIFE,
        PSYS_SRC_MAX_AGE, 0.0,
        PSYS_SRC_BURST_RATE, currentRate,
        PSYS_SRC_BURST_PART_COUNT, 1,
        
        PSYS_SRC_ACCEL, <0.0, 0.0, RISE_SPEED>,
        PSYS_SRC_BURST_SPEED_MIN, 0.2,
        PSYS_SRC_BURST_SPEED_MAX, 0.5,
        PSYS_SRC_ANGLE_BEGIN, 0.0,
        PSYS_SRC_ANGLE_END, PI,
        PSYS_SRC_BURST_RADIUS, 4.0,
        
        PSYS_SRC_TEXTURE, "b4ba225c-373f-446d-9f7e-6cb7b5cf9b3d"
    ]);
}

stopFog()
{
    llParticleSystem([]);
}

default
{
    state_entry()
    {
        llSetText("fog emitter :3 (kind of .-.)", <1.0, 1.0, 1.0>, 1.0);
        llVolumeDetect(TRUE);
        llListen(CHANNEL, "", "", "");
        
        currentAlpha = PARTICLE_ALPHA_START;
        currentRate = EMIT_RATE;
        
        if (fogEnabled)
        {
            startFog();
            llOwnerSay("touch to toggle or use menu");
        }
    }
    
    touch_start(integer num)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            fogEnabled = !fogEnabled;
            
            if (fogEnabled)
            {
                startFog();
                llOwnerSay("fog enabled");
            }
            else
            {
                stopFog();
                llOwnerSay("fog disabled");
            }
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (llGetOwnerKey(id) != llGetOwner()) return;
        
        if (message == "FOG_ON")
        {
            fogEnabled = TRUE;
            startFog();
        }
        else if (message == "FOG_OFF")
        {
            fogEnabled = FALSE;
            stopFog();
        }
        else if (message == "DENSITY_UP")
        {
            currentAlpha += 0.05;
            if (currentAlpha > 1.0) currentAlpha = 1.0;
            if (fogEnabled) startFog();
            llOwnerSay("density: " + (string)((integer)(currentAlpha * 100)) + "%");
        }
        else if (message == "DENSITY_DOWN")
        {
            currentAlpha -= 0.05;
            if (currentAlpha < 0.05) currentAlpha = 0.05;
            if (fogEnabled) startFog();
            llOwnerSay("density: " + (string)((integer)(currentAlpha * 100)) + "%");
        }
        else if (message == "PARTICLES_UP")
        {
            currentRate -= 0.02;
            if (currentRate < 0.01) currentRate = 0.01;
            if (fogEnabled) startFog();
            llOwnerSay("particle rate: " + (string)currentRate);
        }
        else if (message == "PARTICLES_DOWN")
        {
            currentRate += 0.02;
            if (currentRate > 1.0) currentRate = 1.0;
            if (fogEnabled) startFog();
            llOwnerSay("particle rate: " + (string)currentRate);
        }
    }
    
    link_message(integer sender, integer num, string message, key id)
    {
        if (message == "FOG_ON")
        {
            fogEnabled = TRUE;
            startFog();
            llOwnerSay("fog enabled");
        }
        else if (message == "FOG_OFF")
        {
            fogEnabled = FALSE;
            stopFog();
            llOwnerSay("fog disabled");
        }
        else if (message == "DENSITY_UP")
        {
            currentAlpha += 0.05;
            if (currentAlpha > 1.0) currentAlpha = 1.0;
            if (fogEnabled) startFog();
            llOwnerSay("density: " + (string)((integer)(currentAlpha * 100)) + "%");
        }
        else if (message == "DENSITY_DOWN")
        {
            currentAlpha -= 0.05;
            if (currentAlpha < 0.05) currentAlpha = 0.05;
            if (fogEnabled) startFog();
            llOwnerSay("density: " + (string)((integer)(currentAlpha * 100)) + "%");
        }
        else if (message == "PARTICLES_UP")
        {
            currentRate -= 0.02;
            if (currentRate < 0.01) currentRate = 0.01;
            if (fogEnabled) startFog();
            llOwnerSay("particle rate: " + (string)currentRate);
        }
        else if (message == "PARTICLES_DOWN")
        {
            currentRate += 0.02;
            if (currentRate > 1.0) currentRate = 1.0;
            if (fogEnabled) startFog();
            llOwnerSay("particle rate: " + (string)currentRate);
        }
        else if (message == "RESET")
        {
            currentAlpha = PARTICLE_ALPHA_START;
            currentRate = EMIT_RATE;
            fogEnabled = TRUE;
            startFog();
            llOwnerSay("fog settings reset to defaults");
        }
    }
}