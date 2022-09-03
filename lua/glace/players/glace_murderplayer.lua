


-- Murder Weapon Class names. These are important


-- weapon_mu_knife
-- weapon_mu_magnum


-- Loot Class name: mu_loot
-- Dropped murder knife class name: mu_knife


-- Notes:

-- Team 1 and TEAM_UNASSIGNED is the team spectators are in

-- Team 2 is the team alive players are in


-- End of notes



-- We need to make the list of taunts for ourselves since Murder has the taunt table localized.
local taunts = {}

local function addTaunt(cat, soundFile, sex)
	if !taunts[cat] then
		taunts[cat] = {}
	end
	if !taunts[cat][sex] then
		taunts[cat][sex] = {}
	end
	local t = {}
	t.sound = soundFile
	t.sex = sex
	t.category = cat
	table.insert(taunts[cat][sex], t)
end

// male
addTaunt("help", "vo/npc/male01/help01.wav", "male")

addTaunt("scream", "vo/npc/male01/runforyourlife01.wav", "male")
addTaunt("scream", "vo/npc/male01/runforyourlife02.wav", "male")
addTaunt("scream", "vo/npc/male01/runforyourlife03.wav", "male")
addTaunt("scream", "vo/npc/male01/watchout.wav", "male")
addTaunt("scream", "vo/npc/male01/gethellout.wav", "male")
addTaunt("scream", "vo/k_lab/kl_ahhhh.wav", "male")
addTaunt("scream", "vo/k_lab/kl_hedyno03.wav", "male")
addTaunt("scream", "vo/k_lab/kl_hedyno02.wav", "male")
addTaunt("scream", "vo/k_lab/kl_nocareful.wav", "male")

addTaunt("morose", "vo/npc/female01/question31.wav", "male")
addTaunt("morose", "vo/npc/male01/question30.wav", "male")
addTaunt("morose", "vo/npc/male01/question20.wav", "male")
addTaunt("morose", "vo/npc/male01/question25.wav", "male")
addTaunt("morose", "vo/npc/male01/question15.wav", "male")

addTaunt("funny", "vo/npc/male01/doingsomething.wav", "male")
addTaunt("funny", "vo/npc/male01/busy02.wav", "male")
addTaunt("funny", "vo/npc/male01/gordead_ques07.wav", "male")
addTaunt("funny", "vo/npc/male01/notthemanithought01.wav", "male")
addTaunt("funny", "vo/npc/male01/notthemanithought02.wav", "male")
addTaunt("funny", "vo/npc/male01/question06.wav", "male")
addTaunt("funny", "vo/npc/male01/question09.wav", "male")

// female
addTaunt("help", "vo/npc/female01/help01.wav", "female")

addTaunt("scream", "vo/npc/female01/runforyourlife01.wav", "female")
addTaunt("scream", "vo/npc/female01/runforyourlife02.wav", "female")
addTaunt("scream", "vo/npc/female01/watchout.wav", "female")
addTaunt("scream", "vo/npc/female01/gethellout.wav", "female")

addTaunt("morose", "vo/npc/female01/question30.wav", "female")
addTaunt("morose", "vo/npc/female01/question25.wav", "female")
addTaunt("morose", "vo/npc/female01/question20.wav", "female")
addTaunt("morose", "vo/npc/female01/question15.wav", "female")

addTaunt("funny", "vo/npc/female01/doingsomething.wav", "female")
addTaunt("funny", "vo/npc/female01/busy02.wav", "female")
addTaunt("funny", "vo/npc/female01/gordead_ques07.wav", "female")
addTaunt("funny", "vo/npc/female01/notthemanithought01.wav", "female")
addTaunt("funny", "vo/npc/female01/notthemanithought02.wav", "female")
addTaunt("funny", "vo/npc/female01/question06.wav", "female")
addTaunt("funny", "vo/npc/female01/question09.wav", "female")


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

-- Create a custom convar for murder's taunts
CreateConVar( "glacemurderbots_allowtaunts", 1, FCVAR_ARCHIVE, "If the bots are allowed to taunt or not", 0, 1 )

function SpawnGlaceMurderPlayer()
    local ply = Glace_CreatePlayer( names[ random( #names ) ], nil, "GLACERANDOM" )

    if !IsValid( ply ) then print( "Unable to spawn player! Player limit may have been reached!" ) return end

    ply:Glace_SetThinkTime( 0.1 )

    ply.GlaceBystanderState = "wander"


    -- Since we have to create custom players inside a function, we can have local variables for each unique spawned player

    local closestplayer
    local seetime = 0
    local murderagrochance = 200
    local murderermemory -- This is used so the players can remember who the murder is if they saw him
    local murderagrocurtime = 0
    local id = ply:GetCreationID()
    local gunpickupcooldown = 0

    -- We now make some murder specific functions

    function ply:IsMurderer() -- Returns if we are the murderer
        return self:GetMurderer()
    end

    -- If the provided entity is the murder that we've seen before
    function ply:Glace_RememberMurderer( ent )
        return murderermemory and ( ent:GetBystanderName() == murderermemory[1] and ent:GetPlayerColor() == murderermemory[2] ) or false
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

    function ply:HasKnife() -- Returns if we have the knife
        local weps = self:GetWeapons()

        for k, weapon in ipairs(weps) do
            if weapon:GetClass() == "weapon_mu_knife" then
                return true
            end
        end 

        return false
    end


    -- Trying to AddKeyPress for Right clicks wouldn't be very reliable so we just copy the function here
    function ply:ThrowKnife(force)
        local ent = ents.Create("mu_knife")
        ent:SetOwner(self)
        ent:SetPos(self:GetShootPos())
        local knife_ang = Angle(-28,0,0) + self:EyeAngles()
        knife_ang:RotateAroundAxis(knife_ang:Right(), -90)
        ent:SetAngles(knife_ang)
        ent:Spawn()
    
    
        local phys = ent:GetPhysicsObject()
        phys:SetVelocity(self:GetAimVector() * (force * 1000 + 200))
        phys:AddAngleVelocity(Vector(0, 1500, 0))

        local wep = self:GetActiveWeapon()
    
        if IsValid( wep ) then
            wep:Remove()
        end
    end

    -- Murder's taunt console command translated to a function here since console commands can't be run on bots
    function ply:Glace_muTaunt( tauntype )
        if !GetConVar( "glacemurderbots_allowtaunts" ):GetBool() then return end

        if self.LastTaunt && self.LastTaunt > CurTime() then return end
        if !self:Alive() then return end
        if self:Team() != 2 then return end
    
        if !taunts[tauntype] then return end
    
        local sex = string.lower(self.ModelSex or "male")
        if !taunts[tauntype][sex] then return end
    
        local taunt = table.Random(taunts[tauntype][sex])
        self:EmitSound(taunt.sound)
    
        self.LastTaunt = CurTime() + SoundDuration(taunt.sound) + 0.3
    end


--[[     function ply:Glace_CancelMove() 
        GlaceBase_DebugPrint( self, " Cancelled Move \n", debug.traceback() )
        self._GlaceAbortMove = self._GlaceIsMoving or false
    end ]]


    function ply:Glace_OnKilled( attacker, inflictor )
        self.GlaceBystanderState = "wander"
    end 

    -- All players are respawned when a new round starts so we can use this to reset some data
    function ply:Glace_OnSpawn()
        self.GlaceBystanderState = "wander"
        murderagrochance = #team.GetPlayers( 2 ) == 2 and 10 or murderagrochance
        murderermemory = nil
        self.GlaceMurderTarget = nil
        self.GlaceMagnumTarget = nil
    end

    -- If we get stuck just move backwards for a moment and hope we get out
    function ply:Glace_OnStuck()
        GlaceBase_DebugPrint( "Player got stuck" )

        
        self:Glace_SetForwardMove( self:GetWalkSpeed() ) 

        self:Glace_AddKeyPress( IN_DUCK, true )
        self:Glace_AddKeyPress( IN_JUMP ) 


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


            -- If we kill our target, Attack any people we see or go back to the wander state
            if victim == self.GlaceMurderTarget then
                self:Glace_CancelMove()

                self.GlaceMurderTarget = nil
                self.GlaceBystanderState = "wander"

                local targetcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:IsPlayer() and ent:Alive() and ent != self and self:Glace_CanSee(ent) then return true end end ) 
                
                for k, player in RandomPairs( targetcheck ) do
                    self.GlaceMurderTarget = player
                    self.GlaceBystanderState = "murderattackplayer"
                    return
                end

                self:Glace_Timer( math.Rand( 0, 1 ), function()

                    self:Glace_SwitchWeapon( "weapon_mu_hands" )
                    
                end)

                if self:GetLootCollected() > 0 then
                    local ragdollcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:GetClass() == "prop_ragdoll" and self:Glace_CanSee(ent) then return true end end ) 
    
                    for k, rag in RandomPairs( ragdollcheck ) do
                        self.RagdollTarget = rag
                        self.GlaceBystanderState = "disguiseself"
                    end
                end
                

            end


        elseif self:HasMagnum() then

            -- Go back to normal after the murderer is dead
            if victim == self.GlaceMagnumTarget then

                self:Glace_CancelMove()
                self.GlaceMagnumTarget = nil
                self.GlaceBystanderState = "wander"

                self:Glace_Timer( math.Rand( 0, 1 ), function()

                    self:Glace_SwitchWeapon("weapon_mu_hands")
                    
                end)
                
            end

        end

    end




    local taunttypes = {
        "funny",
        "help",
        "scream",
        "morose"
    }


    function ply:Glace_Think()
        if !self:Alive() or self:IsFrozen() then return end

        self:Glace_CheckForDoors()


        if random( 1, 200 ) == 1 then self:Glace_muTaunt( taunttypes[ random( 4 ) ] ) end -- Randomly use taunts
 

        if self.GlaceBystanderState != "gettingdroppedmagnum" and !self:IsMurderer() and CurTime() > gunpickupcooldown then -- Get the dropped gun and try to save the day

            local guncheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:GetClass() == "weapon_mu_magnum" and self:Glace_CanSee(ent) and !IsValid( ent:GetOwner() ) then return true end end ) 

            for k, v in ipairs( guncheck ) do
                if IsValid( v ) then
                    self.GlaceFoundGun = v
                    self.GlaceBystanderState = "gettingdroppedmagnum"
                    self:Glace_CancelMove()
                end
            end

        end

        if self:IsMurderer() then

            -- As time goes on, increase the chance the murderer will get murderous 
            if CurTime() > murderagrocurtime and murderagrochance > 3 then
                murderagrochance = murderagrochance - 1

                murderagrocurtime = CurTime() + 0.5
            end


            
            -- If we have thrown our knife, go get it back
            if self.GlaceBystanderState != "gettingdroppedknife" then
                local knifecheck = self:Glace_FindInSphere( 1500, function( ent ) if ent:GetClass() == "weapon_mu_knife" and !IsValid( ent:GetOwner() ) then return true end end ) 
                    
                if #knifecheck > 0 then
                    GlaceBase_DebugPrint(self, " Going to dropped Knife" )

                    for k, ent in RandomPairs( knifecheck ) do
                        self:Glace_CancelMove()
                        self.Glacedroppedknife = ent
                        self.GlaceBystanderState = "gettingdroppedknife"
                    end

                    return
                end

            end

            if !self:HasKnife() then return end


            -- Throw our knife if we want to
            if IsValid( self:GetActiveWeapon() ) and self:GetActiveWeapon():GetClass() == "weapon_mu_knife" and random(1,100) == 1 then
                GlaceBase_DebugPrint(self, " Throwing knife" )
                self:ThrowKnife( math.Rand( 0, 1 ) )
            end

            

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

            if IsValid( self.GlaceMurderTarget ) and self.GlaceMurderTarget:Alive() then -- When we decide to, kill someone and all witnesses

                if self:Glace_CanSee( self.GlaceMurderTarget ) then
                    seetime = CurTime()+6
                elseif CurTime() > seetime then
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

                -- Conceal knife until we are close to our target
                if self:Glace_GetRangeSquaredTo( self.GlaceMurderTarget ) < ( 150 * 150 ) then
                    self:Glace_SwitchWeapon("weapon_mu_knife")
                end

                self.GlaceBystanderState = "murderattackplayer"
                
                -- Attack the target
                if self:Glace_GetRangeSquaredTo( self.GlaceMurderTarget ) <= ( 100 * 100 ) then
                    self:Glace_AddKeyPress( IN_ATTACK ) 
                end

                return
            end
            
            -- Find someone to attack passively
            if random( murderagrochance ) == 1 then
                GlaceBase_DebugPrint( "Murder target check" )

                local targetcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:IsPlayer() and ent:Alive() and ent != self and self:Glace_CanSee(ent) then return true end end ) 
                
                if #targetcheck < 3 or murderagrochance < 10 then
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

            if IsValid( self.GlaceMagnumTarget ) and self.GlaceMagnumTarget:Alive() then

                if self:Glace_CanSee( self.GlaceMagnumTarget ) then
                    seetime = CurTime() + 6
                elseif CurTime() > seetime then

                    GlaceBase_DebugPrint( "Player with 357 lost their target" )
                    self:Glace_CancelMove()
                    self.GlaceMagnumTarget = nil
                    self.GlaceBystanderState = "wander"
                    self:Glace_SwitchWeapon("weapon_mu_hands")

                end

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

            local targetcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:IsPlayer() and ent:Alive() and ent != self and self:Glace_CanSee( ent ) and ( IsValid( ent:GetActiveWeapon() ) and ent:GetActiveWeapon():GetClass() == "weapon_mu_knife" or ent:GetMurdererRevealed() or self:Glace_RememberMurderer( ent ) ) then return true end end ) 
                
            for k, player in ipairs( targetcheck ) do
                self:Glace_CancelMove()
                self.GlaceMagnumTarget = player
                self.GlaceBystanderState = "attackmurder"
            end

        else
            self.GlaceMurderTarget = nil
            self.GlaceMagnumTarget = nil
            murderagrochance = 200
        end



        -- Look at a player that we can see until we get too far or look at the murderer when he is attacking
        local plycheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:IsPlayer() and ent:Alive() and ent != self and self:Glace_CanSee(ent) and ( random(100) == 1 or ( IsValid( ent:GetActiveWeapon() ) and ent:GetActiveWeapon():GetClass() == "weapon_mu_knife" or ent:GetMurdererRevealed() ) ) then return true end end ) 
        

        closestplayer = IsValid( closestplayer ) and closestplayer or self:Glace_GetClosestEnt( plycheck )

        
        if !murderermemory and IsValid( closestplayer ) and  ( closestplayer:GetActiveWeapon():IsValid() and closestplayer:GetActiveWeapon():GetClass() == "weapon_mu_knife" or closestplayer:GetMurdererRevealed() ) then
            murderermemory = { closestplayer:GetBystanderName(), closestplayer:GetPlayerColor() }
        end

        if IsValid( closestplayer ) and self:Glace_GetRangeSquaredTo( closestplayer ) <= ( 500 * 500 ) then
            self:Glace_Face( closestplayer )
        else
            closestplayer = nil
            self:Glace_StopFace()
        end

        
        if self.GlaceBystanderState != "gettingloot" then

            local lootcheck = self:Glace_FindInSphere( 1000, function( ent ) if ent:GetClass() == "mu_loot" and self:Glace_CanSee(ent) then return true end end ) 

            for k, v in ipairs( lootcheck ) do
                if IsValid( v ) then
                    self.GlaceFoundLoot = v
                    self.GlaceBystanderState = "gettingloot"
                    self:Glace_CancelMove()
                end
            end

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
                GlaceBase_DebugPrint(self, " Picked up loot" )
                hook.Run( "PlayerPickupLoot", self, loot )
            end

            self.GlaceBystanderState = "wander"
            self:Glace_StopFace()

        elseif self.GlaceBystanderState == "murderattackplayer" then
            GlaceBase_DebugPrint(self, " Murderer Attacking innocents" )

            if random( 1, 5 ) == 1 then
                self:Glace_SwitchWeapon("weapon_mu_knife")
            end

            local target = self.GlaceMurderTarget

            self:Glace_Sprint( true )
            self:Glace_Face( target )
            self:Glace_MoveToPos( target, nil, nil, 0.1, true )
            self:Glace_StopFace()
            self:Glace_Sprint( false )

        elseif self.GlaceBystanderState == "attackmurder" then
            local target = self.GlaceMagnumTarget

            GlaceBase_DebugPrint(self, " Attacking murderer" )

            if !IsValid( target ) then self.GlaceBystanderState = "wander" return end

            self:Glace_Sprint( true )
            self:Glace_Face( target )
            
            self:Glace_MoveToPos( self:Glace_CanSee( target ) and ( target:GetPos() + self:Glace_GetNormalTo( target ) * -200 ) or target:GetPos(), nil, nil )
            self:Glace_StopFace()
            self:Glace_Sprint( false )
            

        elseif self.GlaceBystanderState == "gettingdroppedmagnum" then

            local gun = self.GlaceFoundGun

            self:Glace_Face( gun )

            self:Glace_Timer( 0.1, function()
                if !IsValid( gun ) or self.GlaceBystanderState != "gettingdroppedmagnum" then return "remove" end

                if IsValid( gun:GetOwner() ) then self:Glace_CancelMove() return "remove" end
            
            end, "pickupknifecheck", 0 )

            self:Glace_MoveToPos( gun, nil, nil, 0.1, true )
            
            gunpickupcooldown = CurTime()+10

            GlaceBase_DebugPrint(self, "Grabbed Dropped gun" )

            self:Glace_CancelMove()

            self.GlaceBystanderState = "wander"
            self:Glace_StopFace()

        elseif self.GlaceBystanderState == "disguiseself" then


            self:Glace_MoveToPos( self.RagdollTarget, nil, nil )

            coroutine.wait( math.Rand(0,1) )

            GlaceBase_DebugPrint(self, "Murder disguised" )

            self:MurdererDisguise(self.RagdollTarget)
            self:SetLootCollected(self:GetLootCollected() - 1)

            self.GlaceBystanderState = "wander"

        elseif self.GlaceBystanderState == "gettingdroppedknife" then

            local knife = self.Glacedroppedknife

            self:Glace_Face( knife )

            self:Glace_Timer( 0.1, function()
                if !IsValid( gun ) or self.GlaceBystanderState != "gettingdroppedmagnum" then return "remove" end

                if IsValid( knife:GetOwner() ) then self:Glace_CancelMove() return "remove" end
            
            end, "pickupknifecheck", 0 )

            self:Glace_MoveToPos( knife, nil, 5, 0.1, true )
    

            GlaceBase_DebugPrint(self, "Grabbed Dropped knife" )

            self:Glace_StopFace()

            if IsValid( self.GlaceMurderTarget ) and self.GlaceMurderTarget:Alive() then
                self.GlaceBystanderState = "murderattackplayer"
            else
                self.GlaceBystanderState = "wander"
            end

            
        end



    end
    

end


-- "Register" the player so we can spawn them
concommand.Add("glacebase_spawnglacemurderplayer",SpawnGlaceMurderPlayer)