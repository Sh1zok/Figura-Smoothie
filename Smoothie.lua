--[[
    ■■■■■ Smoothie
    ■   ■ Author: Sh1zok
    ■■■■  v0.60
]]--

local smoothie = {}



function smoothie:newSmoothHead(modelPart)
    -- Checking the validity of the parameter
    assert(type(modelPart) == "ModelPart", "Invalid argument to function newSmoothHead. Expected ModelPart, but got " .. type(table))
    modelPart:setParentType("NONE") -- Preparing modelPart

    -- Setting up some variables
    local interface = {}
    local headModelPart = modelPart
    local strenght = 1
    local speed = 1
    local tiltMultiplier = 1
    local keepVanillaPosition = true
    local headRotPrevFrame = vec(0, 0, 0)

    -- Head rotation processor
    events.RENDER:register(function(_, context)
        -- Checking the need to process the head rotation
        if not player:isLoaded() then return end
        if not (context == "RENDER" or context == "FIRST_PERSON" or context == "MINECRAFT_GUI") then return end
        if headModelParts == {} then return end

        -- Math part
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

        -- Applying new head rotation
        headModelPart:setOffsetRot(headRot)
        headRotPrevFrame = headRot

        -- Fixing crouching pose
        if keepVanillaPosition then headModelPart:setPos(-vanilla_model.HEAD:getOriginPos()) end
    end, "Smoothie.SmoothHead")

    --[[
        Interface
    ]]--
    function interface:setStrenght(value)
        if value == nil then value = 1 end
        assert(type(value) == "number", "Invalid argument to function setStrenght. Expected number, but got " .. type(value))
        strenght = value

        return interface -- Returns interface for chaining
    end
    function interface:strenght(value) return interface:setStrenght(value) end  -- Alias

    function interface:setSpeed(value)
        if value == nil then value = 1 end
        assert(type(value) == "number", "Invalid argument to function setSpeed. Expected number, but got " .. type(value))
        speed = value

        return interface -- Returns interface for chaining
    end
    function interface:speed(value) return interface:setSpeed(value) end  -- Alias

    function interface:setTiltMultiplier(value)
        if value == nil then value = 1 end
        assert(type(value) == "number", "Invalid argument to function setTiltMultiplier. Expected number, but got " .. type(value))
        tiltMultiplier = value

        return interface -- Returns interface for chaining
    end
    function interface:tiltMultiplier(value) return interface:setTiltMultiplier(value) end  -- Alias

    function interface:setKeepVanillaPosition(state)
        if state == nil then state = true end
        assert(type(state) == "boolean", "Invalid argument to function setKeepVanillaPosition. Expected boolean, but got " .. type(state))
        keepVanillaPosition = state

        return interface -- Returns interface for chaining
    end
    function interface:keepVanillaPosition(state) return interface:setKeepVanillaPosition(state) end -- Alias

    return interface
end



function smoothie:newEye(modelPart)
    -- Checking the validity of the parameter
    assert(type(modelPart) == "ModelPart", "Invalid argument to function newEye. Expected ModelPart, but got " .. type(table))

    -- Setting up some variables
    local interface = {}
    local eyeModelPart = modelPart
    local offsetStrenght = {top = 1, bottom = 1, left = 1, right = 1}

    -- Eye processor
    events.RENDER:register(function(_, context)
        -- Checking the need to process the head rotation
        if not player:isLoaded() then return end
        if not (context == "RENDER" or context == "FIRST_PERSON" or context == "MINECRAFT_GUI") then return end
        if not eyeModelPart then return end

        -- Math part
        local vanillaHeadRot = (vanilla_model.HEAD:getOriginRot() + 180) % 360 - 180

        -- Applying new eye offset
        eyeModelPart:setPos(
            math.clamp(
                -math.sign(vanillaHeadRot[2]) * ((vanillaHeadRot[2] / 60) ^ 2),
                -offsetStrenght.left,
                offsetStrenght.right
            ),
            math.clamp(
                math.sign(vanillaHeadRot[1]) * ((vanillaHeadRot[1] / 125) ^ 2),
                -offsetStrenght.bottom,
                offsetStrenght.top
            ),
            0
        )
    end, "Smoothie.EyeProcessor")

    function interface:setTopOffsetStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setTopOffsetStrenght. Expected number, but got " .. type(value))
        offsetStrenght.top = value

        return interface
    end
    function interface:topOffsetStrenght(value) return interface:setTopOffsetStrenght(value) end

    function interface:setBottomOffsetStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setBottomOffsetStrenght. Expected number, but got " .. type(value))
        offsetStrenght.bottom = value

        return interface
    end
    function interface:bottomOffsetStrenght(value) return interface:setBottomOffsetStrenght(value) end

    function interface:setLeftOffsetStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setLeftOffsetStrenght. Expected number, but got " .. type(value))
        offsetStrenght.left = value

        return interface
    end
    function interface:leftOffsetStrenght(value) return interface:setLeftOffsetStrenght(value) end

    function interface:setRightOffsetStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setRightOffsetStrenght. Expected number, but got " .. type(value))
        offsetStrenght.right = value

        return interface
    end
    function interface:rightOffsetStrenght(value) return interface:setRightOffsetStrenght(value) end

    return interface
end

return smoothie
