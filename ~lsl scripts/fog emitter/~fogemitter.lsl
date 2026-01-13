vector FOG_COLOR = <0.9, 0.9, 0.9>;
float PARTICLE_SIZE_START = 5.0;
float PARTICLE_SIZE_END = 12.0;
float PARTICLE_ALPHA_START = 0.2;
float PARTICLE_ALPHA_END = 0.0;
float EMIT_RATE = 0.05;
float PARTICLE_LIFE = 25.0;
float RISE_SPEED = 0.1;

integer CHANNEL = 0;
integer fogEnabled = TRUE;
float currentAlpha = 0.2;
float currentRate = 0.15;

vector fogDirection = <0.0, 0.5, 0.0>;
float horizontalSpeed = 0.1;

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
        
        PSYS_SRC_ACCEL, fogDirection,
        PSYS_SRC_BURST_SPEED_MIN, 0.05,
        PSYS_SRC_BURST_SPEED_MAX, 0.15,
        PSYS_SRC_ANGLE_BEGIN, 0.0,
        PSYS_SRC_ANGLE_END, PI * 0.3,
        PSYS_SRC_BURST_RADIUS, 1.0,
        
        PSYS_SRC_TEXTURE, ""
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
        llSetText("fog emitter :3 (kind of .-.)", <0.0, 1.0, 2.0>, 1.0);
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
        else if (message == "ROLL_NORTH")
        {
            fogDirection = <horizontalSpeed, 0.0, RISE_SPEED>;
            if (fogEnabled) startFog();
            llOwnerSay("fog rolling north");
        }
        else if (message == "ROLL_SOUTH")
        {
            fogDirection = <-horizontalSpeed, 0.0, RISE_SPEED>;
            if (fogEnabled) startFog();
            llOwnerSay("fog rolling south");
        }
        else if (message == "ROLL_EAST")
        {
            fogDirection = <0.0, horizontalSpeed, RISE_SPEED>;
            if (fogEnabled) startFog();
            llOwnerSay("fog rolling east");
        }
        else if (message == "ROLL_WEST")
        {
            fogDirection = <0.0, -horizontalSpeed, RISE_SPEED>;
            if (fogEnabled) startFog();
            llOwnerSay("fog rolling west");
        }
        else if (message == "ROLL_UP")
        {
            fogDirection = <0.0, 0.0, RISE_SPEED>;
            if (fogEnabled) startFog();
            llOwnerSay("fog rolling upward");
        }
        else if (message == "SPEED_UP")
        {
            horizontalSpeed += 0.1;
            if (horizontalSpeed > 1.5) horizontalSpeed = 1.5;
            llOwnerSay("fog speed: " + (string)horizontalSpeed);
        }
        else if (message == "SPEED_DOWN")
        {
            horizontalSpeed -= 0.1;
            if (horizontalSpeed < 0.1) horizontalSpeed = 0.1;
            llOwnerSay("fog speed: " + (string)horizontalSpeed);
        }
        else if (message == "NORTHEAST")
        {
            fogDirection = <horizontalSpeed * 0.7, horizontalSpeed * 0.7, RISE_SPEED>;
            if (fogEnabled) startFog();
            llOwnerSay("fog rolling northeast");
        }
        else if (message == "NORTHWEST")
        {
            fogDirection = <horizontalSpeed * 0.7, -horizontalSpeed * 0.7, RISE_SPEED>;
            if (fogEnabled) startFog();
            llOwnerSay("fog rolling northwest");
        }
        else if (message == "SOUTHEAST")
        {
            fogDirection = <-horizontalSpeed * 0.7, horizontalSpeed * 0.7, RISE_SPEED>;
            if (fogEnabled) startFog();
            llOwnerSay("fog rolling southeast");
        }
        else if (message == "SOUTHWEST")
        {
            fogDirection = <-horizontalSpeed * 0.7, -horizontalSpeed * 0.7, RISE_SPEED>;
            if (fogEnabled) startFog();
            llOwnerSay("fog rolling southwest");
        }
        else if (message == "RISE_UP")
        {
            RISE_SPEED += 0.05;
            if (RISE_SPEED > 1.0) RISE_SPEED = 1.0;
            if (fogEnabled) startFog();
            llOwnerSay("rise speed: " + (string)RISE_SPEED);
        }
        else if (message == "RISE_DOWN")
        {
            RISE_SPEED -= 0.05;
            if (RISE_SPEED < 0.0) RISE_SPEED = 0.0;
            if (fogEnabled) startFog();
            llOwnerSay("rise speed: " + (string)RISE_SPEED);
        }
        else if (message == "RESET")
        {
            currentAlpha = PARTICLE_ALPHA_START;
            currentRate = EMIT_RATE;
            fogDirection = <0.0, 0.0, 0.2>;
            RISE_SPEED = 0.2;
            horizontalSpeed = 0.3;
            fogEnabled = TRUE;
            startFog();
            llOwnerSay("fog settings reset to defaults");
        }
    }
}