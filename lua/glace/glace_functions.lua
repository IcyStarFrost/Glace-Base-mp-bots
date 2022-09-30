

-- Setup the default functions. Some functions can be safely overriden after creation of a Player
-- All functions are named Glace_ to prevent any potential conflicts. Anything is possible when someone has 600+ addons

-- Most of the Variables are used in the glace_hooks.lua file since it contains the most important hook to these players, StartCommand.

local net = net
local util = util
local math = math
local table = table
local navmesh = navmesh
local ents = ents
local IsValid = IsValid
local TraceLine = util.TraceLine
local QuickTrace = util.QuickTrace
local ipairs = ipairs

function _GlaceSetupPlayerFunctions( ply ) -- ONLY USED IN THE Glace_CreatePlayer FUNCTION!


    ------------------------------------------------------------------------------------------
    --       The functions below I recommend you don't override after Player Creation.      --
    --       Don't forget that Player Methods work on these guys too.                       --
    ------------------------------------------------------------------------------------------
    
    

    function ply:Glace_SwitchWeapon( weaponname ) -- Makes the player switched to the specified weapon class
        if IsValid( self:GetActiveWeapon() ) and self:GetActiveWeapon():GetClass() == weaponname then return end
        
        self._GlaceRequestedWep = self:GetWeapon( weaponname )
        if !IsValid( self._GlaceRequestedWep ) then return end
        self._GlaceRequestSwitchWep = true
    end

    -- Simulates a press on the specified key. This basically runs CMoveData:AddKey( number keys ) and removes the key after a 0.01 delay
    -- See Enums/IN in the Garry's Mod Wiki for valid keys


    -- shouldholdbool | If the specified key should be held
    -- To remove a hold, just specify the key again without a true in shouldholdbool
    function ply:Glace_AddKeyPress( inkeynum, shouldholdbool ) 

        if !shouldholdbool then
            self._GlaceKeyQueue[ inkeynum ] = inkeynum
            self._GlaceHeldKeyQueue[ inkeynum ] = nil
        else
            self._GlaceHeldKeyQueue[ inkeynum ] = inkeynum
        end
        
    end

    function ply:Glace_SetAutoReload( bool ) -- If the Player should reload when their clip is empty. Note that this may override normal ply:Glace_AddKeyPress( IN_RELOAD ) reload requests
        ply._GlaceAutoReload = bool or false
    end

    function ply:Glace_CancelMove() -- Stops the Player if he is currently moving 
        self._GlaceAbortMove = self._GlaceIsMoving or false
    end

    function ply:Glace_IsMoving() -- Returns if the Player moving or not
        return self._GlaceIsMoving or false
    end

    -- Makes the player move forward or backwards at the specified rate. This will override MoveToPos movement. Set to nil to stop
    function ply:Glace_SetForwardMove( num ) 
        self._GlaceForwardMove = num
    end

    -- Makes the player move right or left depending if the number is negative or not. Set to nil to stop
    function ply:Glace_SetSideMove( num ) 
        self._GlaceRightMove = num
    end

    function ply:Glace_Sprint( bool ) -- Makes the player sprint
        self._GlaceSprinting = bool or false
    end

    function ply:Glace_IsSprinting() -- Returns if the Player is sprinting or not
        return self._GlaceSprinting or false
    end

    function ply:Glace_Face( pos ) -- Makes the Player face a position or entity
        self._GlaceFacePosition = pos
    end

    function ply:Glace_IsFacing() -- Returns who or where the player is facing
        return self._GlaceFacePosition
    end

    function ply:Glace_StopFace() -- Stops the player from facing a certain position or entity. Same thing as ply:Glace_Face( nil )
        self._GlaceFacePosition = nil
    end

    function ply:Glace_SetThinkTime( time ) -- How often the Player's Think function should run in seconds. If we for example set self:Glace_SetThinkTime( 1 ), then the Player's think function will run every 1 second.
        self._GlaceThinkTime = time
    end

    -- Custom Find in sphere function local to the player with the ability to filter out the result
    -- Return true in a filter function to allow the entity to be in the returned table.
    -- Example, function(ent) if ent:IsNPC() or ent:IsPlayer() then return true end end. Only NPCs and Players will be in the returned table
    function ply:Glace_FindInSphere( radius, filter ) 
         
        local entities = ents.FindInSphere( self:GetPos(), radius )

        if isfunction( filter ) then -- If the dev has a filter function, then filter out what they don't want in the table this function returns
            local foundents = {}

            for k, v in ipairs( entities ) do
                if !IsValid( v ) then continue end
                if v == self then continue end

                if filter( v ) == true then -- Test the filter
                    foundents[ #foundents + 1 ] = v -- Add the approved ent to the table
                end

            end

            return foundents

        else -- If there is no filter then just return what we found originally

            return entities
        end
    end

    function ply:Glace_CreateHook( hookname, uniquename, func ) -- Creates a custom hook
        local id = self:GetCreationID()
        hook.Add( hookname, "GlaceBase_CustomHook" .. uniquename .. id, function(...) 
            func(...)
        end)
    end

    function ply:Glace_RemoveHook( hookname, uniquename ) -- Removes a custom hook
        local id = self:GetCreationID()
        hook.Remove( hookname, "GlaceBase_CustomHook" .. uniquename .. id )
    end



    -- Makes the player say a sound file in voice chat and returns the duration of the file
    -- I recommend you only use .wav sound files so a accurate sound duration can be returned
    function ply:Glace_SaySoundFile( path, bypasshook, noicon ) -- path STRING | The sound path to say   bypasshook BOOL | If the function shouldn't test the Can hear hook   noicon BOOL | If the player should have a voice icon above their head
        if self._GlaceIsSpeaking then return end -- So the player can't speak twice

        local playerscanhear = {}

        for k, v in ipairs( player.GetHumans() ) do 
            local canhear, _3dsound = hook.Run( "PlayerCanHearPlayersVoice", v, self )

            playerscanhear[ #playerscanhear + 1 ] = { v, canhear, _3dsound } -- v = The Player that will hear this Player speak | canhear if the listening player can hear this | _3dsound = if the sound should be 3d
        end

        self._GlaceIsSpeaking = true

        local dur = SoundDuration( path )

        for k, tbl in ipairs( playerscanhear ) do
            if !tbl[2] and !bypasshook then GlaceBase_DebugPrint( tbl[1], " can't hear ", self ) continue end

            net.Start( "glacebase_voicechat" ) -- Send the net message in glace_mpbot_autorun.lua
                net.WriteUInt( dur, 32 ) -- Duration
                net.WriteString( path ) -- File path
                net.WriteEntity( self ) -- The Player entity which is ourselves
                net.WriteBool( tbl[3] or false ) -- If the sound should be 3d
                net.WriteBool( noicon or false ) -- If the Player should have a speaker icon above their head
            net.Send( tbl[1] )
        end

        self:Glace_Timer( dur, function()  
            self._GlaceIsSpeaking = false
        end)

        return dur
    end

    -- Sets or creates a new variable on this player that will be networked to all clients when changed. This can only be called on the Server
    function ply:Glace_SetNVar( name, newvalue )
        self.GlaceDataTable = self.GlaceDataTable or {}
        
        self.GlaceDataTable[ name ] = newvalue
        
        net.Start( "glacebase_updatenetvar" )
             net.WriteString( name )
             net.WriteEntity( self )
             net.WriteType( newvalue )
        net.Broadcast()
    end

    -- Gets a networked value from the provided name. This function will work Client Side
    function ply:Glace_GetNVar( name )
        return self.GlaceDataTable[ name ] or nil
    end

    ------------------------------------------------------------------------------------------




    ------------------------------------------------------------------------------------------
    --          You can override all functions below after you create the player            --
    --          if you wish.                                                                --
    ------------------------------------------------------------------------------------------


    ---- Hooks you can use in your Player ----
    -- These are commented cause they are meant to be set in post creation. See the glace_testplayer.lua

    // This hook is called when the Player is killed

    --function ply:Glace_OnKilled( attacker, inflictor )
    --end 



    // This hook is called when the Player is hurt

    --function ply:Glace_OnHurt( attacker, newhealth, damage )
    --end



    // This hook is just a Think hook
    // See ply:Glace_SetThinkTime( time ) to control the interval of the hook

    --function ply:Glace_Think()
    --end



    // This hook is called when a NPC, Nextbot, or Player that isn't us is killed 
    // Generally the same hook as Nextbot's OnOtherKilled

    --function ply:Glace_OnOtherKilled( victim, attacker, inflictor )
    --end



    // Same as Nextbot's ENT:RunBehaviour() except this is internally in a while true loop so it'll constantly re-run the function after it finishes the entire function
    // Certain default functions have to be used in this hook

    --function ply:Glace_ThreadedThink()
    --end



    // This hook is called when the player spawns or respawns

    --function ply:Glace_OnSpawn()
    --end



    // This hook is called when the player thinks they are stuck

    --function ply:Glace_OnStuck()
    --end


    ---- End of the Hooks ----



    

    -- Default Nextbot function moved to the Glace base
    -- This must be used in the ply:Glace_ThreadedThink() function!
    function ply:Glace_PlaySequenceAndWait( name, speed )

        local len = self:SetSequence( name )
        speed = speed or 1
    
        self:ResetSequenceInfo()
        self:SetCycle( 0 )
        self:SetPlaybackRate( speed )
    
        -- wait for it to finish
        coroutine.wait( len / speed )
    
    end


    function ply:Glace_SelectRandomWeapon() -- Makes the player switch to a random weapon they have
        local weps = self:GetWeapons()
        self:Glace_SwitchWeapon( weps[ math.random( #weps ) ]:GetClass() )
    end

    -- A timer function that can either be a Simple timer or a normal one.
    -- This will automatically check if the Player is valid 

    -- Simple timer example, self:Glace_Timer( 5, function() print("Simple timer end")  end )  -- Will run after 5 seconds has passed
    -- Named timer example, self:Glace_Timer( 5, function() print("Named timer tick")  end, "normaltimer", 10 ) -- Will run every 5 seconds until it ran 10 times 

    function ply:Glace_Timer( time, func, name, runcount ) 
        local id = self:GetCreationID()

        if !name and !runcount then

            timer.Simple( time, function() 
                if !IsValid(self) then return end
                func()
            end )

        else

            timer.Create( "GlaceBase_Timer" .. name .. id, time, runcount, function() 
                if !IsValid(self) then timer.Remove( "GlaceBase_Timer" .. name .. id ) return end

                local returns = func() 

                if returns == "remove" then self:Glace_RemoveTimer( name ) end -- if the function returns "remove" then it will remove the named timer

            end )

        end
    end

    function ply:Glace_RemoveTimer( name ) -- Self explanatory. Removes a time made by Glace_Timer
        local id = self:GetCreationID()
        timer.Remove( "GlaceBase_Timer" .. name .. id )
    end

    -- Default Nextbot RangeTo functions translated to Glace Base
    function ply:Glace_GetRangeTo( to )
        to = isentity( to ) and to:GetPos() or to
        return self:GetPos():Distance( to )
    end

    function ply:Glace_GetRangeSquaredTo( to )
        to = isentity( to ) and to:GetPos() or to
        return self:GetPos():DistToSqr( to )
    end

    local doorClasses = {
        ["prop_door_rotating"]=true,
        ['func_door']=true,
        ['func_door_rotating']=true
    }

    function ply:Glace_IsEntDoor( ent ) -- Checks if the entity is a door
        return doorClasses[ ent:GetClass() ] or false
    end

    function ply:Glace_DoorIsOpen( door ) -- Checks if the door is open
	
        local doorClass = door:GetClass()
    
        if ( doorClass == "func_door" or doorClass == "func_door_rotating" ) then
    
            return door:GetInternalVariable( "m_toggle_state" ) == 0
    
        elseif ( doorClass == "prop_door_rotating" ) then
    
            return door:GetInternalVariable( "m_eDoorState" ) ~= 0
    
        else
    
            return false
    
        end
    
    end

    function ply:Glace_GetClosestEnt( tbl ) -- Gets the closest entity in a table. Should be a sequential table full of entities
        local closestent
        local closestdist 

        for k, v in ipairs( tbl ) do
            if !closestent then closestent = v closestdist = self:Glace_GetRangeSquaredTo( v ) continue end

            if self:Glace_GetRangeSquaredTo( v ) < closestdist then
                closestent = v
                closestdist = self:Glace_GetRangeSquaredTo( v )
            end

        end

        return closestent
    end

    function ply:Glace_CheckForDoors() -- Checks for doors near us and attempt to open them automatically. For use in the Think hook
        if self.GlaceOpeningdoor then return end
        local nearbydoors = self:Glace_FindInSphere( 20, function( ent ) if self:Glace_IsEntDoor( ent ) and !self:Glace_DoorIsOpen( ent ) then return true end end )

        local door = self:Glace_GetClosestEnt( nearbydoors )

        if IsValid( door ) then
            debugoverlay.Line( self:EyePos(), door:GetPos(), 1, Color(0,200,0), true )

            GlaceBase_DebugPrint("Opening a Door")
            self.GlaceOpeningdoor = true

            local oldface = self:Glace_IsFacing()

                

            self:Glace_Face( door )
            door:Use(self,self)

            self:Glace_SetForwardMove( -self:GetWalkSpeed() ) 

            self:Glace_Timer(0.6,function()

                self:Glace_SetForwardMove( nil ) 

                self:Glace_Face( oldface )

                self:Glace_Timer(2,function()
                    self.GlaceOpeningdoor = nil
                end)
                    
            end)

        end

    end


    function ply:Glace_ActiveAmmoName() -- Returns the ammo type the player's weapon is using
        local wep = self:GetActiveWeapon()

        if !IsValid( wep ) then return "failed" end -- If this ever happens

        local id = wep:GetPrimaryAmmoType()

        return game.GetAmmoName(id)
    end


    function ply:Glace_GetNormalTo( to ) -- Returns a normal direction from our position towards "to"
        to = isentity(to) and to:GetPos() or to
        local norm = ( to - self:GetPos() ):GetNormalized()
        return norm
    end

    function ply:Glace_FindNavAreas( distance ) -- Return nav areas within this distance. I didn't like how the default finds worked
        local navs = navmesh.GetAllNavAreas()

        local validnavs = {}

        distance = distance or 1500

        for k,v in ipairs(navs) do

            local point = v:GetClosestPointOnArea( self:GetPos() )

            if IsValid( v ) and point:DistToSqr( self:GetPos() ) < ( distance * distance ) then
                table.insert( validnavs, v )
            end

        end

        return validnavs
      end


    function ply:Glace_GetRandomPosition( distance ) -- Gets a random position within this distance
        local navs = self:Glace_FindNavAreas( distance )

        for k, v in RandomPairs( navs ) do

            if IsValid( v ) and ( v:GetSizeX() > 75 and v:GetSizeY() > 75 ) then -- Filter out small nav areas or else the player would favor the hundreds of tiny nav areas
                return v:GetRandomPoint()
            end

        end
    end

    -- See https://wiki.facepunch.com/gmod/CNavArea:GetHidingSpots for valid types
    -- This will return a table of tables of vectors
    function ply:Glace_FindSpots( distance, type )
        local navs = self:Glace_FindNavAreas( distance )
        local spots = {}

        for k, v in ipairs( navs ) do
            if !IsValid( v ) then continue end

            spots[ #spots + 1 ] = v:GetHidingSpots( type )

        end

        return spots
    end



    -- If the player can see the entity in their field of view
    function ply:Glace_CanSee( ent )
        if !IsValid( ent ) then return false end
        
        if !self:Visible( ent ) then return false end


          local fov = self:GetFOV()

          local dir = ( ent:GetPos() - self:EyePos() )

          local distance = dir:Length()

          local MaxCos = math.abs( math.cos( math.acos( distance / math.sqrt( distance * distance + self:BoundingRadius() * 0.5 * ent:BoundingRadius() * 0.5 ) ) + fov * ( math.pi / 180 ) ) )
          
          dir:Normalize()
          
          if dir:Dot( self:EyeAngles():Forward() ) > MaxCos then
            return true
          end
          
        return false  
    end




    -- This must be used in the ply:Glace_ThreadedThink() function!
    function ply:Glace_MoveToPos( pos, lookahead, goaltoler, updaterate, waitforowner ) -- Makes the player move to a specified position or to a entity. 

        local pathfinder = ents.Create("glace_glacepathfinder") -- Create the pathfinder
        pathfinder:SetPos(self:GetPos())

        pathfinder.MovePos = pos
        pathfinder.LookAhead = lookahead
        pathfinder.Goaltol = goaltoler
        pathfinder.UpdateRate = updaterate
        pathfinder.GlaceOwner = self
        pathfinder.ShouldWaitForOwner = waitforowner -- This can make the pathfinder wait for its Player to reach itself when it reaches its goal instead of deleting itself instantly

        pathfinder:Spawn()
        
        self._GlacePathfinderENT = pathfinder

        while IsValid( pathfinder ) do -- Yield while the Pathfinder is active
            coroutine.yield()
        end

    end


    -- Gmod's default pathfinding function
    -- The pathfinder uses this to calculate its pathfinding
    -- Feel free to edit this in post player creation to your liking so you can improve it's pathfinding or so.
    function ply:PathfindFunction(loco)
        return function( area, fromArea, ladder, elevator, length )
            if ( !IsValid( fromArea ) ) then

                // first area in path, no cost
                return 0
            
            else
            
                if ( !loco:IsAreaTraversable( area ) ) then
                    // our locomotor says we can't move here
                    return -1
                end

                // compute distance traveled along path so far
                local dist = 0

                if ( IsValid( ladder ) ) then
                    dist = ladder:GetLength()
                elseif ( length > 0 ) then
                    // optimization to avoid recomputing length
                    dist = length
                else
                    dist = ( area:GetCenter() - fromArea:GetCenter() ):GetLength()
                end

                local cost = dist + fromArea:GetCostSoFar()

                // check height change
                local deltaZ = fromArea:ComputeAdjacentConnectionHeightChange( area )
                if ( deltaZ >= loco:GetStepHeight() ) then
                    if ( deltaZ >= loco:GetMaxJumpHeight() ) then
                        // too high to reach
                        return -1
                    end

                    // jumping is slower than flat ground
                    local jumpPenalty = 5
                    cost = cost + jumpPenalty * dist
                elseif ( deltaZ < -loco:GetDeathDropHeight() ) then
                    // too far to drop
                    return -1
                end

                return cost
            end
        end
    end



end -- Setup End