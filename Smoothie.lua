--[[
    ■■■■■ Smoothie
    ■   ■ Author: Sh1zok
    ■■■■  v0.25
]]--

local smoothie = {}

function smoothie:newSmoothHead()
    --[[
        Setting up some variables
    ]]--
    local interface = {}
    local headModelParts = {}
    local strenght = 1
    local speed = 1
    local tiltMultiplier = 1
    local keepVanillaPosition = true
    local headRotPrevFrame = vec(0, 0, 0)

    events.RENDER:register(function(_, context)
        if not player:isLoaded() then return end
        if not (context == "RENDER" or context == "FIRST_PERSON") then return end
        if headModelParts == {} then return end

        local headRot = math.lerp(
            headRotPrevFrame,
            ((vanilla_model.HEAD:getOriginRot() + 180) % 360 - 180) * strenght,
            math.min(8 / client:getFPS() * speed, 1)
        )
        headRot[3] = math.lerp(
            headRotPrevFrame[3],
            2.5 * ((vanilla_model.HEAD:getOriginRot() + 180) % 360 - 180)[2] / 50 * tiltMultiplier,
            math.min(8 / client:getFPS() * speed, 1)
        )

        for _, table in ipairs(headModelParts) do table[1]:setOffsetRot(headRot * table[2]) end
        headRotPrevFrame = headRot
        if keepVanillaPosition then headModelParts[1][1]:setPos(-vanilla_model.HEAD:getOriginPos()) end
    end, "Smoothie.smoothHeadProcessor")

    function interface:setHeadModelPart(table)
        if table == nil then table = {} end
        if type(table) == "ModelPart" then table = {{table, 1}} end
        assert(type(table) == "table", "Invalid argument to function setHeadModelPart. Expected table or ModelPart, but got " .. type(table))
        for _, innerTable in ipairs(headModelParts) do innerTable[1]:setParentType("HEAD") end
        for _, innerTable in ipairs(table) do innerTable[1]:setParentType("NONE") end
        headModelParts = table

        return interface
    end
    function interface:headModelPart(modelPart) return interface:setHeadModelPart(modelPart) end

    function interface:setStrenght(value)
        if value == nil then value = 1 end
        assert(type(value) == "number", "Invalid argument to function setStrenght. Expected number, but got " .. type(value))
        strenght = value

        return interface
    end
    function interface:strenght(value) return interface:setStrenght(value) end

    function interface:setSpeed(value)
        if value == nil then value = 1 end
        assert(type(value) == "number", "Invalid argument to function setSpeed. Expected number, but got " .. type(value))
        speed = value

        return interface
    end
    function interface:speed(value) return interface:setSpeed(value) end

    function interface:setTiltMultiplier(value)
        if value == nil then value = 1 end
        assert(type(value) == "number", "Invalid argument to function setTiltMultiplier. Expected number, but got " .. type(value))
        tiltMultiplier = value

        return interface
    end
    function interface:tiltMultiplier(value) return interface:setTiltMultiplier(value) end

    function interface:setKeepVanillaPosition(state)
        if state == nil then state = true end
        assert(type(state) == "boolean", "Invalid argument to function setKeepVanillaPosition. Expected boolean, but got " .. type(state))
        keepVanillaPosition = state

        return interface
    end
    function interface:keepVanillaPosition(state) return interface:setKeepVanillaPosition(state) end

    return interface
end

return smoothie
