--[[
    ■■■■■ Smoothie
    ■   ■ Author: Sh1zok
    ■■■■  v0.7.0

MIT License

Copyright (c) 2025 Sh1zok

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local smoothie = {}



function smoothie:newSmoothHead(modelPart)
    -- Checking the validity of the parameter
    assert(type(modelPart) == "ModelPart", "Invalid argument to function newSmoothHead. Expected ModelPart, but got " .. type(modelPart))
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
    assert(type(modelPart) == "ModelPart", "Invalid argument to function newEye. Expected ModelPart, but got " .. type(modelPart))

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
    function interface:topOffsetStrenght(value) return interface:setTopOffsetStrenght(value) end -- Alias

    function interface:setBottomOffsetStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setBottomOffsetStrenght. Expected number, but got " .. type(value))
        offsetStrenght.bottom = value

        return interface
    end
    function interface:bottomOffsetStrenght(value) return interface:setBottomOffsetStrenght(value) end -- Alias

    function interface:setLeftOffsetStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setLeftOffsetStrenght. Expected number, but got " .. type(value))
        offsetStrenght.left = value

        return interface
    end
    function interface:leftOffsetStrenght(value) return interface:setLeftOffsetStrenght(value) end -- Alias

    function interface:setRightOffsetStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setRightOffsetStrenght. Expected number, but got " .. type(value))
        offsetStrenght.right = value

        return interface
    end
    function interface:rightOffsetStrenght(value) return interface:setRightOffsetStrenght(value) end -- Alias

    return interface
end



function smoothie:newEar(modelPart)
    -- Checking the validity of the parameter
    assert(type(modelPart) == "ModelPart", "Invalid argument to function newHorizontalEar. Expected ModelPart, but got " .. type(modelPart))

    -- Setting up some variables
    local interface = {}
    local earModelPart = modelPart
    local headRotationDelta, prevHeadRotationAngle = vec(0, 0, 0), vec(0, 0, 0)
    local speed, bouncy = 1, 1
    local earRotationVelocity = vec(0, 0, 0)
    local rotationLimits = {top = 10, bottom = 10, left = 45, right = 45}

    -- Ear rotation logic
    events.RENDER:register(function()
        -- Calculating the difference in head rotation
        local headRotationAngle = (vanilla_model.HEAD:getOriginRot() + 180) % 360 - 180
        headRotationDelta = headRotationDelta + (prevHeadRotationAngle - headRotationAngle)
        headRotationDelta[1] = math.clamp(headRotationDelta[1], -rotationLimits.bottom, rotationLimits.top)
        headRotationDelta[2] = math.clamp(headRotationDelta[2], -rotationLimits.left, rotationLimits.right)
        prevHeadRotationAngle = headRotationAngle

        -- Calculation the speed of rotation and the rotation of the ear itself
        earRotationVelocity = earRotationVelocity + -(speed * (earModelPart:getOffsetRot() - headRotationDelta) + math.sqrt(speed * 20) * bouncy * earRotationVelocity) / client:getFPS()
        earModelPart:setOffsetRot(earModelPart:getOffsetRot() + earRotationVelocity / client:getFPS())

        -- Soft reduction of head deviation to zeros
        headRotationDelta = math.lerp(headRotationDelta, vec(0, 0, 0), 5 / client:getFPS())
    end, "Smoothie.horizontalEarProcessor")

    function interface:setBouncy(value)
        assert(type(value) == "number", "Invalid argument to function setBouncy. Expected number, but got " .. type(value))
        bouncy = value

        return interface
    end
    function interface:boucny(value) return interface:setBouncy(value) end -- Alias

    function interface:setSpeed(value)
        assert(type(value) == "number", "Invalid argument to function setSpeed. Expected number, but got " .. type(value))
        speed = value

        return interface
    end
    function interface:speed(value) return interface:setSpeed(value) end -- Alias

    function interface:setTopLimit(value)
        assert(type(value) == "number", "Invalid argument to function setTopLimit. Expected number, but got " .. type(value))
        rotationLimits.top = value

        return interface
    end
    function interface:topLimit(value) return interface:setTopLimit(value) end -- Alias

    function interface:setBottomLimit(value)
        assert(type(value) == "number", "Invalid argument to function setBottomLimit. Expected number, but got " .. type(value))
        rotationLimits.bottom = value

        return interface
    end
    function interface:bottomLimit(value) return interface:setBottomLimit(value) end -- Alias

    function interface:setLeftLimit(value)
        assert(type(value) == "number", "Invalid argument to function setLeftLimit. Expected number, but got " .. type(value))
        rotationLimits.left = value

        return interface
    end
    function interface:leftLimit(value) return interface:setLeftLimit(value) end -- Alias

    function interface:setRightLimit(value)
        assert(type(value) == "number", "Invalid argument to function setRightLimit. Expected number, but got " .. type(value))
        rotationLimits.right = value

        return interface
    end
    function interface:rightLimit(value) return interface:setRightLimit(value) end -- Alias

    return interface
end

return smoothie
