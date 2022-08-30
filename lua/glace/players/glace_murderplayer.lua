


-- Murder Weapon Class names. These are important


-- weapon_mu_knife
-- weapon_mu_magnum


-- Loot Class name: mu_loot
-- Dropped murder knife class name: mu_knife


-- Notes:

-- Team 1 and TEAM_UNASSIGNED is the team spectators are in

-- Team 2 is the team alive players are in


-- End of notes

local zetanames = file.Read("zetaplayerdata/names.json","DATA")

zetanames = util.JSONToTable(zetanames)

local random = math.random

function SpawnGlaceMurderPlayer()
    local ply = Glace_CreatePlayer( zetanames[ random( #zetanames ) ], nil, nil, "GLACERANDOM" )

    ply:Glace_SetThinkTime( 0.1 )

    ply.GlaceBystanderState = "wander"

    -- We now make some murder specific functions

    function ply:IsMurderer() -- Returns if we are the murderer
        return self:GetMurderer()
    end

    function ply:HasMagnum() -- Returns if we have the gun
        local weps = self:GetWeapons()

        for k, weapon in ipairs(weps) do
            if weapon:GetClass() == "weapon_mu_magnum" then
                return true
            end
        end 

        return false
    end





    function ply:Glace_OnKilled( attacker, inflictor )
        self.GlaceBystanderState = "wander"
    end 

    -- If we get stuck just move backwards for a moment and hope we get out
    -- If we are in water too, then go forward for a longer time so we hopefully get out by being "jumped" onto a ledge
    function ply:Glace_OnStuck()
        GlaceBase_DebugPrint( "Player got stuck" )

        self:SetCollisionGroup( COLLISION_GROUP_WORLD )
        
        self:Glace_SetForwardMove( -self:GetWalkSpeed() )

        self:Glace_Timer( 5, function()

            self:SetCollisionGroup( COLLISION_GROUP_NONE )

        end, "unstucknocollide", 1 )

        self:Glace_Timer( 0.5, function()
            self:Glace_CancelMove()
            self:Glace_SetForwardMove( nil )
        end )
    end

    function ply:Glace_OnOtherKilled( victim, attacker, inflictor )
        if self:IsMurderer() then

            if victim == self.GlaceMurderTarget then
                self:Glace_CancelMove()

                self.GlaceMurderTarget = nil
                self.GlaceBystanderState = "wander"

                self:Glace_SwitchWeapon( "weapon_mu_hands" )

                local targetcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:IsPlayer() and ent:Alive() and ent != self and self:Glace_CanSee(ent) then return true end end ) 
                
                for k, player in RandomPairs( targetcheck ) do
                    self.GlaceMurderTarget = player
                    self.GlaceBystanderState = "murderattackplayer"
                end

            end


        elseif self:HasMagnum() then

            if victim == self.GlaceMagnumTarget then

                self:Glace_CancelMove()
                self.GlaceMagnumTarget = nil
                self.GlaceBystanderState = "wander"
                self:Glace_SwitchWeapon("weapon_mu_hands")
            end

        end

    end



    local closestplayer
    local murderseetime = 0

    function ply:Glace_Think()
        if !self:Alive() or self:IsFrozen() then return end

        self:Glace_CheckForDoors()

        if ply.GlaceBystanderState != "gettingloot" then

            local lootcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:GetClass() == "mu_loot" and self:Glace_CanSee(ent) then return true end end ) 

            for k, v in ipairs( lootcheck ) do
                if IsValid( v ) then
                    ply.GlaceFoundLoot = v
                    ply.GlaceBystanderState = "gettingloot"
                    self:Glace_CancelMove()
                end
            end

        end

        if ply.GlaceBystanderState != "gettingdroppedmagnum" and !self:IsMurderer() then -- Get the dropped gun and try to save the day

            local guncheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:GetClass() == "weapon_mu_magnum" and self:Glace_CanSee(ent) and !IsValid( ent:GetOwner() ) then return true end end ) 

            for k, v in ipairs( guncheck ) do
                if IsValid( v ) then
                    ply.GlaceFoundGun = v
                    ply.GlaceBystanderState = "gettingdroppedmagnum"
                    self:Glace_CancelMove()
                end
            end

        end

        if self:IsMurderer() then

            if self.GlaceBystanderState == "murderattackplayer" then -- Attack the closest player 
                local targetcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:IsPlayer() and ent:Alive() and ent != self and self:Glace_CanSee(ent) then return true end end ) 

                local closestplayer = self:Glace_GetClosestEnt( targetcheck )

                if IsValid( closestplayer ) then
                    GlaceBase_DebugPrint( "Switching to closest target" )
                    self:Glace_Face(closestplayer)
                    self._GlacePathfinderENT.MovePos = closestplayer
                    self.GlaceMurderTarget = closestplayer
                end
            end

            if IsValid( self.GlaceMurderTarget ) then -- When we decide to, kill someone and all witnesses

                if self:Glace_CanSee( self.GlaceMurderTarget ) then
                    murderseetime = CurTime()+6
                elseif CurTime() > murderseetime then
                    GlaceBase_DebugPrint( "Murderer lost their target" )
                    self:Glace_CancelMove()
                    self.GlaceMurderTarget = nil
                    self.GlaceBystanderState = "wander"
                    self:Glace_SwitchWeapon("weapon_mu_hands")
    
                    local targetcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:IsPlayer() and ent:Alive() and ent != self and self:Glace_CanSee(ent) then return true end end ) 
                    
                    for k, player in RandomPairs( targetcheck ) do
                        self.GlaceMurderTarget = player
                        self.GlaceBystanderState = "murderattackplayer"
                    end
                    return
                end

                self:Glace_SwitchWeapon("weapon_mu_knife")
                self.GlaceBystanderState = "murderattackplayer"
                
                if self:Glace_GetRangeSquaredTo( self.GlaceMurderTarget ) <= ( 100 * 100 ) then
                    self:Glace_AddKeyPress( IN_ATTACK ) 
                end

                return
            end

            if random( 1, 20 ) == 1 then
                GlaceBase_DebugPrint( "Murder target check" )

                local targetcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:IsPlayer() and ent:Alive() and ent != self and self:Glace_CanSee(ent) then return true end end ) 
                
                if #targetcheck < 3 then
                    for k, player in RandomPairs( targetcheck ) do
                        self:Glace_CancelMove()
                        self.GlaceMurderTarget = player
                        self.GlaceBystanderState = "murderattackplayer"
                    end
                end

            end

        elseif self:HasMagnum() then -- If we see the murderer, try to take the shot and kill him once and for all

            if IsValid( self.GlaceMagnumTarget ) then
                if !self.GlacePullOutGunTime then
                    self.GlacePullOutGunTime = CurTime()+math.Rand(0,1.5)
                end

                if CurTime() > self.GlacePullOutGunTime then
                    self:Glace_SwitchWeapon("weapon_mu_magnum")
                end

                if self:Glace_CanSee( self.GlaceMagnumTarget ) then
                    self:SetEyeAngles( ( self:Glace_GetNormalTo( self.GlaceMagnumTarget:WorldSpaceCenter() + VectorRand(-60,60) ) ):Angle() )
                    self:Glace_AddKeyPress( IN_ATTACK )
                end

                return
            end

            local targetcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:IsPlayer() and ent:Alive() and ent != self and self:Glace_CanSee( ent ) and ( ent:GetActiveWeapon():GetClass() == "weapon_mu_knife" or ent:GetMurdererRevealed() ) then return true end end ) 
                
            for k, player in ipairs( targetcheck ) do
                self:Glace_CancelMove()
                self.GlaceMagnumTarget = player
                self.GlaceBystanderState = "attackmurder"
            end

        else
            self.GlaceMurderTarget = nil
            self.GlaceMagnumTarget = nil
        end



        -- Look at a player that we can see until we get too far or look at the murderer when he is attacking
        local plycheck = self:Glace_FindInSphere( 400, function( ent ) if ent:IsPlayer() and ent:Alive() and ent != self and self:Glace_CanSee(ent) and ( random(50) == 1 or ( ent:GetActiveWeapon():GetClass() == "weapon_mu_knife" or ent:GetMurdererRevealed() ) ) then return true end end ) 

        closestplayer = IsValid( closestplayer ) and closestplayer or self:Glace_GetClosestEnt( plycheck )

        if IsValid( closestplayer ) and self:Glace_GetRangeSquaredTo( closestplayer ) <= ( 400 * 400 ) then
            self:Glace_Face( closestplayer )
        else
            closestplayer = nil
            self:Glace_StopFace()
        end



    end

    function ply:Glace_ThreadedThink()
        if !self:Alive() or self:IsFrozen() then return end


        if self.GlaceBystanderState == "wander" then

            local pos = self:Glace_GetRandomPosition( 1500 )

            self:Glace_MoveToPos( pos )

        elseif self.GlaceBystanderState == "gettingloot" then

            local loot = self.GlaceFoundLoot

            self:Glace_Face( loot )


            self:Glace_MoveToPos( loot, nil, nil, nil, true )


            coroutine.wait( math.Rand(0,1) )

            if IsValid( loot ) then
                hook.Run( "PlayerPickupLoot", self, loot )
                self:Glace_SaySoundFile( "vo/npc/male01/gotone0" .. random(1,2) .. ".wav" )
            end

            self.GlaceBystanderState = "wander"
            self:Glace_StopFace()

        elseif self.GlaceBystanderState == "murderattackplayer" then
            self:Glace_SwitchWeapon("weapon_mu_knife")

            local target = self.GlaceMurderTarget

            self:Glace_Sprint( true )
            self:Glace_Face( target )
            self:Glace_MoveToPos( target, nil, nil, 0.1, true )
            self:Glace_StopFace()
            self:Glace_Sprint( false )
            self:Glace_SwitchWeapon("weapon_mu_hands")

        elseif self.GlaceBystanderState == "attackmurder" then
            local target = self.GlaceMagnumTarget

            self:Glace_Sprint( true )
            self:Glace_Face( target )
            
            self:Glace_MoveToPos( self:Glace_CanSee( target ) and ( target:GetPos() + self:Glace_GetNormalTo( target ) * -200 ) or target:GetPos(), nil, nil )
            self:Glace_StopFace()
            self:Glace_Sprint( false )
            self:Glace_SwitchWeapon("weapon_mu_hands")

        elseif ply.GlaceBystanderState == "gettingdroppedmagnum" then

            local gun = self.GlaceFoundGun

            self:Glace_Face( gun )


            self:Glace_MoveToPos( gun, nil, nil, nil, true )
            GlaceBase_DebugPrint( "Grabbed Dropped gun" )

            self.GlaceBystanderState = "wander"
            self:Glace_StopFace()

        end


    end


end