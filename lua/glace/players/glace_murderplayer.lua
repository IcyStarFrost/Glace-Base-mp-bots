


-- Murder Weapon Class names. These are important


-- weapon_mu_knife
-- weapon_mu_magnum


-- Loot Class name: mu_loot
-- Dropped murder knife class name: mu_knife


-- Notes:

-- Team 1 and TEAM_UNASSIGNED is the team spectators are in

-- Team 2 is the team alive players are in


-- End of notes


-- Temporary list of names
local names = {
    "Beta",
	"Generic Name 1",
	"Ze Uberman",
	"Q U A N T U M P H Y S I C S",
	"portable fridge",
	"Methman456",
	"i rdm kids for breakfast",
	"Cheese Adiction Therapist",
	"private hoovy",
	"Socks with Sandals",
	"Solar",
	"AdamYeBoi",
	"troll",
	"de_struction and de_fuse",
	"de_rumble",
	"decoymail",
	"Damian",
	"BrandontheREDSpy",
	"Braun",
	"brent13",
	"BrokentoothMarch",
	"BruH",
	"BudLightVirus",
	"Call of Putis",
	"CanadianBeaver",
	"Cake brainer",
	"cant scream in space",
	"CaptGravyBoness",
	"CaraKing09",
	"CarbonTugboat",
	"CastHalo",
	"cate",
	"ccdrago56",
	"cduncan05",
	"Chancellor_Ant",
	"Changthunderwang",
	"Charstorms",
	"Ch33kCLaper69",
	"Get Good Get Lmao Box",
	"Atomic",
	"Audrey",
	"Auxometer",
	"A Wise Author",
	"Awtrey516",
	"Aytx",
	"BabaBooey",
	"BackAlleyDealerMan",
	"BalieyeatsPizza",
	"ballzackmonster",
	"Banovinski",
	"bardochib",
	"BBaluka",
	"Bean man",
	"Bear",
	"Bearman_18",
	"beeflover100",
	"Albeon Stormhammer",
	"Andromedus",
	"Anilog",
	"Animus",
	"Sorry_an_Error_has_Occurred",
	"I am the Spy",
	"engineer gaming",
	"Ze Uberman",
	"Regret",
	"Sora",
	"Sky",
	"Scarf",
	"Graves",
	"bruh moment",
	"Garrys Mod employee",
	"i havent eaten in 69 days",
	"DOORSTUCK89",
	"PickUp That Can Cop",
	"Never gonna give you up",
	"if you are reading this, ur mom gay ",
	"The Lemon Arsonist",
	"Cave Johnson",
	"Chad",
	"Speedy",
	"Alan"
}

local random = math.random

function SpawnGlaceMurderPlayer()
    local ply = Glace_CreatePlayer( names[ random( #names ) ], nil, nil, "GLACERANDOM" )

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
    function ply:Glace_OnStuck()
        GlaceBase_DebugPrint( "Player got stuck" )

        self:SetCollisionGroup( COLLISION_GROUP_WORLD )
        
        self:Glace_SetForwardMove( self:GetWalkSpeed() ) 

        self:Glace_AddKeyPress( IN_DUCK, true )
        self:Glace_AddKeyPress( IN_JUMP ) 

        self:Glace_Timer( 3, function()

            self:SetCollisionGroup( COLLISION_GROUP_NONE )

        end, "unstucknocollide", 1 )


        self:Glace_Timer( 1, function()

            self:Glace_SetForwardMove() -- Stop the override movement
            self:Glace_AddKeyPress( IN_DUCK ) -- Releases the hold on the crouch key

        end, "crouchrelease", 1 )


        
        self:Glace_Timer( 0.5, function()

            
            self:Glace_CancelMove()

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
                    return
                end

                if self:GetLootCollected() > 0 then
                    local ragdollcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:GetClass() == "prop_ragdoll" and self:Glace_CanSee(ent) then return true end end ) 
    
                    for k, rag in RandomPairs( ragdollcheck ) do
                        self.RagdollTarget = rag
                        self.GlaceBystanderState = "disguiseself"
                    end
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

            if random( 1, 60 ) == 1 then
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

        elseif self:HasMagnum() then -- If we see the murderer, try to take the shot and kill him once and for all. Or be a troll :troll:

            if !IsValid( self.GlaceMagnumTarget ) and random(1,500) == 1 then
                local targetcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:IsPlayer() and ent:Alive() and ent != self and self:Glace_CanSee(ent) then return true end end ) 
                

                for k, ply in RandomPairs( targetcheck ) do
                    self:Glace_CancelMove()
                    self.GlaceMagnumTarget = ply
                    self.GlaceBystanderState = "attackmurder"
                end

            end

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
                
                self.GlaceBystanderState = "attackmurder"

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

            if !IsValid( target ) then self.GlaceBystanderState = "wander" return end

            self:Glace_Sprint( true )
            self:Glace_Face( target )
            
            self:Glace_MoveToPos( self:Glace_CanSee( target ) and ( target:GetPos() + self:Glace_GetNormalTo( target ) * -200 ) or target:GetPos(), nil, nil )
            self:Glace_StopFace()
            self:Glace_Sprint( false )
            self:Glace_SwitchWeapon("weapon_mu_hands")

        elseif self.GlaceBystanderState == "gettingdroppedmagnum" then

            local gun = self.GlaceFoundGun

            self:Glace_Face( gun )


            self:Glace_MoveToPos( gun, nil, nil, nil, true )
            GlaceBase_DebugPrint( "Grabbed Dropped gun" )

            self.GlaceBystanderState = "wander"
            self:Glace_StopFace()

        elseif self.GlaceBystanderState == "disguiseself" then


            self:Glace_MoveToPos( self.RagdollTarget, nil, nil )

            coroutine.wait( math.Rand(0,1) )

            GlaceBase_DebugPrint( "Murder disguised" )

            self:MurdererDisguise(self.RagdollTarget)
            self:SetLootCollected(self:GetLootCollected() - 1)

        end


    end


end


-- "Register" the player so we can spawn them
concommand.Add("glacebase_spawnglacemurderplayer",SpawnGlaceMurderPlayer)