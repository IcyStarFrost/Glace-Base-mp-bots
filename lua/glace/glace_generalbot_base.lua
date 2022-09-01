
include("glace/glace_functions.lua")

-- Creates a bot


-- name | The name the player should have
-- model | The model the player should spawn with
-- profilepicture | The image file with extension from materials/glacebase/profilepictures/ the player should use as their profile picture

function Glace_CreatePlayer( name, model, profilepicture )
    if !game.SinglePlayer() and player.GetCount() < game.MaxPlayers() then 
        if !navmesh.IsLoaded() then PrintMessage(HUD_PRINTTALK,"Glace Base Warning: Map has no Navigation Mesh! Preventing Spawn..") return end


        local ply = player.CreateNextBot( name )

        if !IsValid( ply ) then return end

        ply.IsGlacePlayer = true
        ply._GlaceThinkTime = 0
        ply._GlaceKeyQueue = {}
        ply._GlaceHeldKeyQueue = {}

        

        if model then

            ply._GlaceCustomModel = model
            ply:SetModel( model ) -- Set the custom model

        end

        -- Apply the profile picture

        -- All you have to do is provide a image name with its file extension from materials/glacebase/profilepictures/ in the profilepicture arg to give this player a profile picture.
        -- Note voice chat fadeouts will look weird. I do not know how to fix this yet
        timer.Simple( 0, function()

            ply:SetNW2Bool( "glacebase_isglaceplayer", true )

            if profilepicture then

                if profilepicture == "GLACERANDOM" then
                    local pfps,_ = file.Find("materials/glacebase/profilepictures/*","GAME")
                    profilepicture = pfps[ math.random( #pfps ) ]
                end
                
                ply:SetNW2String( "glacebase_profilepicture", profilepicture )

            end

        end)


            ply.threadthink = coroutine.create( function()  -- Kick off the coroutine thread
            while true do
                if isfunction( ply.Glace_ThreadedThink ) then
                    ply:Glace_ThreadedThink()
                end
                coroutine.yield()
            end
        end)

        local id = ply:GetCreationID()
        local thinktime = 0
        local stuckchecktime = 0
        local lastpos 
        hook.Add( "Think", "GlacePlayerThink" .. id, function() -- Initialize the Think hook
            if !IsValid( ply ) then hook.Remove( "Think", "GlacePlayerThink" .. id ) return end

            if CurTime() > thinktime then

                if isfunction( ply.Glace_Think ) then
                    ply:Glace_Think()
                end

                thinktime = CurTime() + ply._GlaceThinkTime
            end

            if ply._GlaceIsMoving and CurTime() > stuckchecktime then
                if !lastpos then

                    lastpos = ply:GetPos()

                elseif ply:GetPos():DistToSqr( lastpos ) <= ( 50 * 50 ) then

                    if isfunction( ply.Glace_OnStuck ) then
                        
                        ply:Glace_OnStuck()
                        
                    end

                end
                
                stuckchecktime = CurTime()+1
            elseif !ply._GlaceIsMoving then
                lastpos = nil
            end

            if !ply.threadthink then return end
            
            if coroutine.status( ply.threadthink ) == "dead" then
                Msg(ply," Warning: Glace Coroutine returned dead!")
                ply.threadthink = nil
            end

            local ok, errormessage = coroutine.resume( ply.threadthink ) -- Keep the Coroutine going if it is still alive


            if ok == false then
                ErrorNoHalt(ply, " Glace Coroutine Thread encountered a error. Error: ", errormessage, "\n")
                ply.threadthink = nil
            end


            

            
        end)

        hook.Add( "PlayerDeath", "GlaceBase_OnOtherKilled" .. id, function( victim, inflictor, attacker )
            if !IsValid( ply ) then hook.Remove( "PlayerDeath", "GlaceBase_OnOtherKilled" .. id ) return end

            if isfunction( ply.Glace_OnOtherKilled ) and victim != ply then

               ply:Glace_OnOtherKilled( victim, attacker, inflictor ) 

            end
        end)

        -- Yes OnNPCKilled should be used instead but some things don't call the OnNPCKilled hook so we need to make sure if the ent is actually killed through this
        hook.Add( "PostEntityTakeDamage", "GlaceBase_OnOtherKilledPstDamage" .. id, function( ent, dmginfo ) 
            if !IsValid( ply ) then hook.Remove( "PostEntityTakeDamage", "GlaceBase_OnOtherKilledPstDamage" .. id ) return end

            if !IsValid( ent ) then return end

            if !ent:IsNPC() and !ent:IsNextBot() or ent:IsPlayer() then return end -- We don't want non NPCs and players to be passed through this hook


            if isfunction( ply.Glace_OnOtherKilled ) and ent:Health() <= 0 then

               ply:Glace_OnOtherKilled( ent, dmginfo:GetAttacker(), dmginfo:GetInflictor() ) 

            end        
        end)




        _GlaceSetupPlayerFunctions( ply ) -- Add the default functions
        

        return ply
    else
        -- Oh fiddle sticks what now?
        local message = !game.SinglePlayer() and player.GetCount() < game.MaxPlayers() and "Server Player limit has been reached!" or game.SinglePlayer() and "These players can only be used in multiplayer!"
        print(message)
    end
end


