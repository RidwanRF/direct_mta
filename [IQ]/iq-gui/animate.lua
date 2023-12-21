function importAnimate()
    return [[local __internal = {
        __internal = {}
    }
    setmetatable(__internal, {
        __index = function(t, key)
            if t.__internal[key] then
                local v = t.__internal[key]
                local progress = math.max(math.min((getTickCount() - v.startTime) / (v.stopTime - v.startTime), 1), 0)
                -- return v.start + (v.stop - v.start) * progress
                return interpolateBetween(v.start, 0, 0, v.stop, 0, 0, progress, v.easing)
            else return 0 end
        end,
        __newindex = function(t, key, value)
            local time = value.time or value[3] or (t.__internal[key] and (t.__internal[key].stopTime - t.__internal[key].startTime)) or 0
            t.__internal[key] = {
                start = value.start or value[1] or (t.__internal[key] and t[key]) or 0,
                stop = value.stop or value[2] or (t.__internal[key] and t.__internal[key].stop) or 0,
                startTime = getTickCount(),
                stopTime = getTickCount() + time,
                easing = value.easing or value[4] or (t.__internal[key] and t.__internal[key].easing) or 'Linear',
            }
        end
    })
    
    return __internal;]]
end