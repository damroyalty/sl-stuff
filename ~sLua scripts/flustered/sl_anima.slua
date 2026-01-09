--!nocheck
-- @diagnostic disable: undefined-global

local HEARTBEAT_UUID = "0077531d-fa99-088b-3c43-dfdf935349ef"
local HEARTBEAT_VOLUME = 0.9
local HEARTBEAT_DURATION = 3.0

local heartbeatActive = false
local heartbeatTimerHandle = nil

function doFlushedEffect(toucherID)
    if not heartbeatActive then
        ll.LoopSound(HEARTBEAT_UUID, HEARTBEAT_VOLUME)
        heartbeatActive = true
    end

    if heartbeatTimerHandle then
        LLTimers:off(heartbeatTimerHandle)
    end
    heartbeatTimerHandle = LLTimers:once(HEARTBEAT_DURATION, function()
        ll.StopSound()
        heartbeatActive = false
        heartbeatTimerHandle = nil
    end)

    local origName = ll.GetObjectName()
    local ownerID = ll.GetOwner()
    
    local ownerName = ll.Key2Name(ownerID)
    ownerName = ll.List2String(ll.ParseString2List(ownerName, {" "}, {}), 0)
    
    local toucherName = ll.Key2Name(toucherID)
    toucherName = ll.List2String(ll.ParseString2List(toucherName, {" "}, {}), 0)
    
    ll.SetObjectName(ownerName)
    
    if toucherID == ownerID then
        ll.Say(0, "/me is totally flustered😳💕")
    else
        ll.Say(0, "/me is totally flustered by " .. toucherName .. "😳💕")
    end
    
    ll.SetObjectName(origName)
    
    ll.ParticleSystem({})
    ll.ParticleSystem({
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_BURST_PART_COUNT, 15,
        PSYS_SRC_BURST_RATE, 0.2,
        PSYS_PART_MAX_AGE, 3.0,
        PSYS_SRC_ACCEL, vector(0, 0, 0.15),
        PSYS_SRC_TEXTURE, "",
        PSYS_SRC_BURST_SPEED_MIN, 0.05,
        PSYS_SRC_BURST_SPEED_MAX, 0.15,
        PSYS_PART_START_SCALE, vector(0.12, 0.12, 0),
        PSYS_PART_END_SCALE, vector(0.05, 0.05, 0),
        PSYS_PART_START_COLOR, vector(1.0, 0.6, 0.75),
        PSYS_PART_END_COLOR, vector(1.0, 0.8, 0.9),
        PSYS_PART_START_ALPHA, 0.9,
        PSYS_PART_END_ALPHA, 0.0,
        PSYS_SRC_MAX_AGE, 1.0,
        PSYS_PART_FLAGS, bit32.bor(PSYS_PART_EMISSIVE_MASK, PSYS_PART_INTERP_COLOR_MASK, PSYS_PART_INTERP_SCALE_MASK)
    })
end

LLEvents:on("state_entry", function()
    ll.PreloadSound(HEARTBEAT_UUID)
    ll.Say(0, "Particle system ready!")
end)

LLEvents:on("touch_start", function(detected)
    local toucherID = detected[1]:getKey()
    doFlushedEffect(toucherID)
end)