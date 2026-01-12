vector FOG_COLOR = <0.8, 0.8, 0.9>; // light gray-blue fog
float PARTICLE_SIZE_START = 6.0;    // starting size of fog particles
float PARTICLE_SIZE_END = 12.0;     // ending size (grows as it rises)
float PARTICLE_ALPHA_START = 0.2;   // starting transparency (0.0-1.0)
float PARTICLE_ALPHA_END = 0.0;     // ending transparency (fades out)
float EMIT_RATE = 0.15;             // particles per second (lower = less lag)
float PARTICLE_LIFE = 8.0;          // how long each particle lives (seconds)
float RISE_SPEED = 0.2;             // how fast fog drifts upward

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

        PSYS_PART_START_SCALE, <PARTICLE_SIZZE_START, PARTICLE_SIZE_START, 0.0>,
        PSYS_PART_END_SCALE, <PARTICLE_SIZE_END, PARTICLE_SIZE_END, 0.0>,

        


        

    ]);
}


default
{
state_entry()
{
    
}
}   