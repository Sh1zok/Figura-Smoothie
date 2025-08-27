--[[
    ■■■■■ Smoothie
    ■   ■ Author: Sh1zok
    ■■■■  v0.25
]]--

local smoothie = {}

function smoothie:newSmoothHead()
    local interface = {}
    local headModelPart
    local strenght = 1
    local speedMultiplier = 1
    local keepVanillaPos = true

    events.RENDER:register(function(_, context)
        if not player:isLoaded() then return end
        if not (context == "RENDER" or context == "FIRST_PERSON") then return end
        if not headModelPart then return end

        headModelPart:setOffsetRot(math.lerp(
            headModelPart:getOffsetRot(),
            ((vanilla_model.HEAD:getOriginRot() + 180) % 360 - 180) * strenght,
            math.min(8 / client:getFPS() * speedMultiplier, 1)
        ))

        if keepVanillaPos then headModelPart:setPos(-vanilla_model.HEAD:getOriginPos()) end
    end, "Smoothie.smoothHeadProcessor")

    function interface:setHeadModelPart(modelPart)
        assert(type(modelPart) == "ModelPart", "Invalid argument to function setHeadModelPart. Expected ModelPart, but got " .. type(modelPart))

        if headModelPart then headModelPart:setParentType("HEAD") end

        modelPart:setParentType("NONE")
        headModelPart = modelPart

        return interface
    end
    function interface:headModelPart(modelPart) return interface:setHeadModelPart(modelPart) end

    function interface:setStrenght(value)
        assert(type(value) == "number", "Invalid argument to function setStrenght. Expected number, but got " .. type(value))
        strenght = value

        return interface
    end
    function interface:strenght(value) return interface:setStrenght(value) end

    return interface
end


return smoothie
