

CreateConVar("glacebase_debug",0,FCVAR_NONE,"Debug",0,1)

include("glace/glace_utilityfunctions.lua")

if SERVER then
    util.AddNetworkString("glacebase_voicechat")

    include("glace/glace_hooks.lua")
    include("glace/glace_generalbot_base.lua")
    

    local files,dirs = file.Find("lua/glace/players/*.lua","GAME")
    
    for k,v in ipairs(files) do 
        include("glace/players/"..v)
        print("Glace: Included ".."glace/players/"..v)
    end

elseif CLIENT then

    include("glace/client/glace_voicechatpfp.lua")

    local voiceicon = Material("voice/icntlk_pl")

    net.Receive( "glacebase_voicechat", function()
        local time = net.ReadUInt( 16 )
        local filename = net.ReadString()
        local ply = net.ReadEntity()
        local _3d = net.ReadBool()

        GlaceBase_DebugPrint("Voice Chat Receive")
        if !IsValid( ply ) then GlaceBase_DebugPrint("Receiving Player isn't valid") return end

        ply._GlaceIsSpeaking = true

        hook.Run( "PlayerStartVoice", ply )

        local id = ply:EntIndex()

        hook.Add( "PreDrawEffects", "GlaceBase_VoiceChatIcon" .. id, function()
            if !IsValid(ply) then hook.Remove( "PreDrawEffects", "GlaceBase_VoiceChatIcon" .. id ) return end

                local ang = EyeAngles()
                local pos = ply:GetPos() + Vector(0, 0, 80)

                ang:RotateAroundAxis(ang:Up(), -90)
                ang:RotateAroundAxis(ang:Forward(), 90)
        
                cam.Start3D2D( pos, ang, 1 )
                    surface.SetMaterial( voiceicon )
                    surface.SetDrawColor( 255, 255, 255 )
                    surface.DrawTexturedRect( -8, -8, 16, 16 )
                cam.End3D2D()
            
        end)

        local flags = !_3d and "" or "3d mono" -- If the sound should be 3d or not

        sound.PlayFile( "sound/" .. filename, flags, function( snd, errorid, errorname )
            if errorid and errorname then
                print(errorname,errorid)
                return
            end




            -- Since the sound is 3d, we need to set its position to the Player's position every frame/tick
            if _3d then 

                hook.Add( "Think", "GlaceBase_VoiceChat3dThink" .. id, function() 
                    if !IsValid(ply) then hook.Remove("Think", "GlaceBase_VoiceChat3dThink" .. id) return end
                    snd:SetPos(ply:GetPos())
                end)

            end

            
            timer.Simple( snd:GetLength(), function()
                if !IsValid( ply ) then return end

                hook.Remove("Think", "GlaceBase_VoiceChat3dThink" .. id)
                hook.Remove( "PreDrawEffects", "GlaceBase_VoiceChatIcon" .. id )
                ply._GlaceIsSpeaking = false
                snd:Stop()

                hook.Run( "PlayerEndVoice", ply )
            end)


        
        end)


    end)

end


-- Shared stuff

local meta = FindMetaTable("Player")
local oldisspeaking = meta.IsSpeaking

function meta:IsSpeaking()
    if self:GetNW2Bool( "glacebase_isglaceplayer", false ) then
        return self._GlaceIsSpeaking or false 
    else
        return oldisspeaking(self)
    end
end