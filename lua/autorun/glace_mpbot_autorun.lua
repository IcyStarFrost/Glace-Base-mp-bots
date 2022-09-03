

CreateConVar( "glacebase_debug", 0, FCVAR_NONE, "Debug", 0, 1 )

include( "glace/glace_utilityfunctions.lua" )

if SERVER then
    util.AddNetworkString( "glacebase_voicechat" )
    util.AddNetworkString( "glacebase_setisglacevar" )
    util.AddNetworkString( "glacebase_dispatchpfp" )

    include( "glace/glace_hooks.lua" )
    include( "glace/glace_generalbot_base.lua" )
    

    local files,dirs = file.Find( "lua/glace/players/*.lua", "GAME" )
    
    for k,v in ipairs( files ) do 
        include("glace/players/"..v)
        print("Glace: Included ".."glace/players/"..v)
    end



elseif CLIENT then

    net.Receive( "glacebase_setisglacevar", function()
        local ply = net.ReadEntity()
        if !IsValid( ply ) then return end

        ply.IsGlacePlayer = true
    end )

end


-- Shared stuff

local meta = FindMetaTable( "Player" )
local oldisspeaking = meta.IsSpeaking

function meta:IsSpeaking()
    if self:GetNW2Bool( "glacebase_isglaceplayer", false ) then
        return self._GlaceIsSpeaking or false 
    else
        return oldisspeaking( self )
    end
end