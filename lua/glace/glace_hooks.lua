

local IsValid = IsValid



hook.Add( "PlayerDeath", "GlaceBase_PlayerDeath", function(ply,inflictor,attacker) -- You are ded not big soup rice
    if !ply.IsGlacePlayer then return end

    if isfunction(ply.Glace_OnKilled) then
        ply:Glace_OnKilled(attacker,inflictor)
    end
end)


-- This.. Took way to much time to figure out how to make the bots move to a direction while still facing a target or so.
-- Why was it this simple?
hook.Add( "SetupMove", "GlaceBase_SetupMove" ,function(ply,mv)
    if !ply.IsGlacePlayer then return end

    if IsValid( ply._GlacePathfinderENT ) then
        local norm =  ( ( ply._GlacePathfinderENT:GetPos() + Vector(0,0,60) ) - ply:GetPos() ):Angle() 
        mv:SetMoveAngles(norm)
    end
end)

hook.Add( "StartCommand", "GlaceBase_UserCommand", function(ply,cmd) -- Can be confusing but that's alright. We make it work
    if !ply.IsGlacePlayer then return end

    cmd:ClearMovement() 
	cmd:ClearButtons()

    if ply._GlaceForwardMove then
        cmd:SetForwardMove( ply._GlaceForwardMove )
    end

    if ply._GlaceRightMove then
        cmd:SetSideMove( ply._GlaceRightMove )
    end
    
    if IsValid( ply._GlacePathfinderENT ) and ply:Glace_GetRangeSquaredTo( ply._GlacePathfinderENT ) >= ( 10 * 10 ) then  -- Watch where you go!

        if !ply._GlaceForwardMove then
            cmd:SetForwardMove( ply:GetRunSpeed() )
        end

        local norm =  ( ( ply._GlacePathfinderENT:GetPos() + Vector(0,0,60) ) - ply:EyePos() ):Angle() 
        if !ply._GlaceFacePosition then
            ply:SetEyeAngles( norm )
        end

    end

    if ply._GlaceFacePosition then -- If the developer wants the player to face something or somewhere
        local pos = isentity( ply._GlaceFacePosition ) and IsValid(ply._GlaceFacePosition) and ply._GlaceFacePosition:GetPos() + ply._GlaceFacePosition:OBBCenter() or isvector(ply._GlaceFacePosition) and ply._GlaceFacePosition or nil
        
        if pos then
            ply:SetEyeAngles( ( pos - ply:EyePos() ):Angle() )
        end
    end

    if ply._GlaceRequestKeyPress then 
        cmd:AddKey( ply._GlaceRequestKeyPress )
        timer.Simple( 0.01, function() cmd:RemoveKey( ply._GlaceRequestKeyPress ) ply._GlaceRequestKeyPress = nil  end )
    end


    if ply._GlaceRequestSwitchWep then -- Switch the weapon if requested
        if IsValid( ply._GlaceRequestedWep ) then 
            cmd:SelectWeapon( ply._GlaceRequestedWep )
        end
        ply._GlaceRequestSwitchWep = false
    end

 
    if ply._GlaceAutoReload and IsValid( ply:GetActiveWeapon() ) and ply:GetActiveWeapon():Clip1() == 0 then -- Auto Reload
        cmd:RemoveKey( IN_ATTACK )
        cmd:AddKey( IN_RELOAD )
    else
        cmd:RemoveKey( IN_RELOAD )
    end

    if ply._GlaceSprinting then -- Sprinting
        cmd:AddKey( IN_SPEED )
    else
        cmd:RemoveKey( IN_SPEED )
    end


end)

hook.Add( "PlayerHurt", "GlaceBase_PlayerHurt", function(ply,attacker,hp,damage) -- Pain simulation 9000
    if !ply.IsGlacePlayer then return end

    if isfunction( ply.Glace_OnHurt ) then
        ply:Glace_OnHurt( attacker, hp, damage )
    end
end)


hook.Add( "EntityTakeDamage", "GlaceBasePathfindernodamage", function(ent,dmg) -- We don't want our precious pathfinder to be killed
    if ent._IsGlacePathfinder then return true end
end)


hook.Add( "PlayerSpawn", "GlaceBase_PlayerSpawn", function( ply )
    if !ply.IsGlacePlayer then return end

    if isfunction( ply.Glace_OnSpawn ) then
        ply:Glace_OnSpawn()
    end
end)

print("Glace: Hooks Initialized")