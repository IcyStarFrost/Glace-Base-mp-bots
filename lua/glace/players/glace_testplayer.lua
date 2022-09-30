
-- Here's a fairly simple Player that will simply walk around and shoot at people sometimes.
-- This will give a good example on the useage of the Glaces. I will be refering them as Players throughout the code.

-- Just localizing some stuff 
local random = math.random


-- This table is used for when we need to know which entity class name we need to look for to get ammo
local ammotranslation = {
    ["Pistol"] = "item_ammo_pistol",
    ["AR2"] = "item_ammo_ar2",
    ["SMG1"] = "item_ammo_smg1",
    ["357"] = "item_ammo_357",
    ["XBowBolt"] = "item_ammo_crossbow",
    ["Buckshot"] = "item_box_buckshot",
    ["RPG_Round"] = "item_rpg_round",

}

-- To start off, we encase the entire player in their own function to spawn them.
function SpawnTestGlacePlayer()
    local ply = Glace_CreatePlayer( "Avui" , nil, "GLACERANDOM" ) -- We create a Player with the name Avui with the kleiner model since the model arg is nil. We also set GLACERANDOM so he gets a random profile picture. See glace_generalbot_base.lua

    if !IsValid( ply ) then print( "Unable to spawn player! Player limit may have been reached!" ) return end -- We need to make sure that we say this and end this function or else we get useless bug reports

    -- We now start making the AI

    ply:Glace_SetAutoReload( true ) -- Make the Player automatically reload when he runs out of ammo
    ply:Glace_SwitchWeapon("weapon_357") -- We make them just use the 357 Magnum for this example
    ply:Glace_SetThinkTime( 0.3 ) -- This Player's Glace_Think hook will now only run after every 0.3 second


    -- For this player, we'll create a form of State System to work with.
    -- We'll create a custom var and a few new functions for this specific Player.
    ply.Glace_State = "idle"

    function ply:Glace_GetState() -- Returns the Glace_State
        return self.Glace_State
    end

    function ply:Glace_SetState( state ) -- Sets the state. We'll be using this to switch from a idle mode to a combat
        self.Glace_LastState = self.Glace_State
        self.Glace_State = state
    end

    function ply:Glace_GetLastState() -- Gets the last state the player was in
        return self.Glace_LastState
    end

    function ply:Glace_SetEnemy( ent ) -- Set the enemy
        self.Glace_Enemy = ent
    end

    function ply:Glace_GetEnemy() -- Get the enemy
        return self.Glace_Enemy
    end



    function ply:Glace_OnKilled( attacker, inflictor ) -- When the player dies, they will drop out of the game

        -- Normally you would want to add a timer for until you want the bot to respawn,
        -- however, for testing purposes of the base and editing, the kick() method is used instead.

        self:Kick()

    end

    function ply:Glace_OnHurt( attacker, hp, damage ) -- Play a generic pain sound
        if attacker == self then return end

        self:EmitSound( "vo/npc/male01/pain0" .. random( 9 ) .. ".wav" )

        if random(1,5) == 1 then -- Attack our attacker if we want to
            self:Glace_CancelMove() 
            self:Glace_SetEnemy( attacker )
            self:Glace_SetState( "incombat" )
        end

    end


    -- Now we create our normal Think hook
    function ply:Glace_Think()

        if random( 50 ) == 1 then
            self:Glace_SaySoundFile( "vo/breencast/br_instinct01.wav" )
        end

        if self:Health() < self:GetMaxHealth()*0.4 and self:Glace_GetState() != "findmedkits" then -- I NEED A MEDIC BAG
            self:Glace_SetState("findmedkits")
            self:Glace_CancelMove()
        end

        if IsValid(self:GetActiveWeapon()) and !self:GetActiveWeapon():HasAmmo() and self:Glace_GetState() != "findammo" then -- If we run out of ammo, then find some
            self:Glace_SetState("findammo")
            self:Glace_CancelMove()
        end

        if self:Glace_GetState() == "incombat" and !IsValid(self.Glace_Enemy) then -- If our enemy isn't valid then just go back to normal
            self:Glace_Sprint( false )
            self:Glace_StopFace()
            self:Glace_SetState( "idle" )
            self:Glace_SetEnemy(nil)
        end

        if IsValid( self.Glace_Enemy ) and self:Glace_CanSee( self.Glace_Enemy ) then -- Shoot at our target if we can see em

            self:Glace_AddKeyPress( IN_ATTACK )
            return 
        end -- If the enemy is valid then don't run the code below

        local surrounding = self:Glace_FindInSphere( 1500, function(ent) if IsValid(ent) and (ent:IsNPC() or ent:IsPlayer()) and self:Glace_CanSee( ent ) then return true end end ) -- Get Nearby NPCs and Players we can see

        for k, v in RandomPairs(surrounding) do -- Select a random target
            if v:IsPlayer() and random(1,10) != 1 then continue end -- Attack the player only randomly

            self:Glace_CancelMove() 
            self:Glace_SetEnemy( v )
            self:Glace_SetState( "incombat" )
            break
        end

    end

    -- This hook is the same as Nextbot's ENT:OnOtherKilled(). This will be called whenever a NPC, Nextbot, or Player that isn't us dies
    function ply:Glace_OnOtherKilled( victim, attacker, inflictor )

        if victim == self:Glace_GetEnemy() then
            self:Glace_Sprint( false )
            self:Glace_StopFace()
            self:Glace_SetState( "idle" )
            self:Glace_SetEnemy(nil)
        end
    end

    function ply:Glace_ThreadedThink() -- Same as Nextbot's ENT:RunBehaviour() except this is internally in a while true loop so it'll constantly run the function after it finishes the entire function
        
        if self:Glace_GetState() == "idle" then -- Idle state will just be wandering

            self:Glace_Sprint( false )

            local pos = self:Glace_GetRandomPosition( 2000 ) -- Get a random spot that we want to go to
            self:Glace_MoveToPos( pos ) -- Go to that spot with the default args

        elseif self:Glace_GetState() == "incombat" and IsValid( self:Glace_GetEnemy() ) then -- Combat State


            -- This timer makes the player bhop
            self:Glace_Timer( 0.4, function()
                if !IsValid( self:Glace_GetEnemy() ) then return "remove" end
                if self:Glace_GetRangeSquaredTo( self:Glace_GetEnemy() ) <= ( 200 * 200 ) then return "remove" end
                if self:Glace_GetState() != "incombat" then return "remove" end  -- We return "remove" so that the timer will remove itself so we don't have to do it. This will be pretty useful
                if self:GetVelocity():Length() < 200 then return end 
                

                self:Glace_AddKeyPress( IN_JUMP )
            end, "bhop", 30 ) 

            -- If we can't see our enemy, then go to their position
            local pos = self:Glace_CanSee( self:Glace_GetEnemy() ) and ( self:Glace_GetEnemy():GetPos() + self:Glace_GetNormalTo( self:Glace_GetEnemy() ) * -400 ) or self:Glace_GetEnemy():GetPos()

            self:Glace_Sprint( true )
            self:Glace_Face( self:Glace_GetEnemy() )
            self:Glace_MoveToPos( pos, nil, nil )

        elseif self:Glace_GetState() == "findmedkits" then -- Find a medkit or perish

            -- Only return medkits
            local surrounding = self:Glace_FindInSphere( 1500, function(ent) if ent:GetClass() == "item_healthkit" or ent:GetClass() == "item_healthvial" then return true end end ) 
            local medkit 

            for k, v in RandomPairs( surrounding ) do
                medkit = v
                break
            end
            
            if IsValid(medkit) then
                self:Glace_Sprint( true )
                self:Glace_StopFace()

                self:Glace_Timer( 0.4, function() -- Bhop to the medkit and pray the enemies never played CSGO for years
                    if !IsValid( medkit ) then return "remove" end
                    if self:Glace_GetRangeSquaredTo( medkit ) <= ( 200 * 200 ) then return "remove" end
                    if self:Glace_GetState() != "findmedkits" then return "remove" end
                    if self:GetVelocity():Length() < 200 then return end 
                     
    
                    self:Glace_AddKeyPress( IN_JUMP )
                end, "bhop", 30 ) 

                self:Glace_MoveToPos( medkit, nil, nil, 3, true ) -- Go to the medkit and have the pathfinder wait for the player
            end
            self:Glace_SetState( self:Glace_GetLastState() )

        elseif self:Glace_GetState() == "findammo" then

            -- Only return the correct ammo type
            local surrounding = self:Glace_FindInSphere( 1500, function(ent) if ent:GetClass() == ammotranslation[self:Glace_ActiveAmmoName()] then return true end end ) 
            local ammo 

            for k, v in RandomPairs( surrounding ) do
                ammo = v
                break
            end
            

            if IsValid(ammo) then -- Go grab that ammo
                self:Glace_Sprint( true )
                self:Glace_StopFace()

                self:Glace_Timer( 0.4, function()
                    if !IsValid( ammo ) then return "remove" end
                    if self:Glace_GetRangeSquaredTo( ammo ) <= ( 200 * 200 ) then return "remove" end
                    if self:Glace_GetState() != "findammo" then return "remove" end
                    if self:GetVelocity():Length() < 200 then return end 
                     
    
                    self:Glace_AddKeyPress( IN_JUMP )
                end, "bhop", 30 ) 

                self:Glace_MoveToPos( ammo, nil, 10, 3, true )
            end
            self:Glace_SetState( self:Glace_GetLastState() )
        end

    end

    

end


-- We now "register" the player as a console command so we can spawn them
concommand.Add("glacebase_spawntestplayer",SpawnTestGlacePlayer)