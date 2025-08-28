--[[
    ■■■■■ Smoothie
    ■   ■ Author: Sh1zok
    ■■■■  v0.50
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
        if not (context == "RENDER" or context == "FIRST_PERSON" or context == "MINECRAFT_GUI") then return end
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

local function newEye(offsets)
    --[[
        Setting up some variables
    ]]--
    local interface = {}
    local eyeModelPart
    local topOffsetStrenght = offsets.top
    local leftOffsetStrenght = offsets.left
    local rightOffsetStrenght = offsets.right
    local bottomOffsetStrenght = offsets.bottom

    events.RENDER:register(function(_, context)
        if not player:isLoaded() then return end
        if not (context == "RENDER" or context == "FIRST_PERSON" or context == "MINECRAFT_GUI") then return end
        if not eyeModelPart then return end

        local vanillaHeadRot = (vanilla_model.HEAD:getOriginRot() + 180) % 360 - 180
        eyeModelPart:setPos(
            math.clamp(
                -math.sign(vanillaHeadRot[2]) * ((vanillaHeadRot[2] / 60) ^ 2),
                -leftOffsetStrenght,
                rightOffsetStrenght
            ),
            math.clamp(
                math.sign(vanillaHeadRot[1]) * ((vanillaHeadRot[1] / 125) ^ 2),
                -bottomOffsetStrenght,
                topOffsetStrenght
            ),
            0
        )
    end, "Smoothie.EyeProcessor")

    function interface:setEyeModelPart(modelPart)
        assert(type(modelPart) == "ModelPart" or type(modelPart) == "nil", "Invalid argument to function setEyeModelPart. Expected ModelPart, but got " .. type(modelPart))
        eyeModelPart = modelPart

        return interface
    end
    function interface:eyeModelPart(modelPart) return interface:setEyeModelPart(modelPart) end

    function interface:setTopOffsetStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setTopOffsetStrenght. Expected number, but got " .. type(value))
        topOffsetStrenght = value

        return interface
    end
    function interface:topOffsetStrenght(value) return interface:setTopOffsetStrenght(value) end

    function interface:setBottomOffsetStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setBottomOffsetStrenght. Expected number, but got " .. type(value))
        bottomOffsetStrenght = value

        return interface
    end
    function interface:bottomOffsetStrenght(value) return interface:setBottomOffsetStrenght(value) end

    function interface:setLeftOffsetStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setLeftOffsetStrenght. Expected number, but got " .. type(value))
        leftOffsetStrenght = value

        return interface
    end
    function interface:leftOffsetStrenght(value) return interface:setLeftOffsetStrenght(value) end

    function interface:setRightOffsetStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setRightOffsetStrenght. Expected number, but got " .. type(value))
        rightOffsetStrenght = value

        return interface
    end
    function interface:rightOffsetStrenght(value) return interface:setRightOffsetStrenght(value) end

    return interface
end
function smoothie.newRightEye() return newEye({top = 0.5, bottom = 0.5, right = 0.66, left = 0.34}) end
function smoothie.newLeftEye() return newEye({top = 0.5, bottom = 0.5, right = 0.34, left = 0.66}) end

return smoothie
