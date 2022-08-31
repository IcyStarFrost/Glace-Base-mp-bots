AddCSLuaFile()
if SERVER then



    function GlaceBase_KickAllBots()

        for k, v in ipairs( player.GetBots() ) do
            v:Kick()
        end

    end

    function GlaceBase_AutoEditNavmesh()
        local areas = navmesh.GetAllNavAreas()
        for k,v in ipairs(areas) do
            local adjareas = v:GetAdjacentAreas()
            for i,l in ipairs(adjareas) do
                if v:ComputeAdjacentConnectionHeightChange(l) > 20 then 
                    v:Disconnect(l)
                end
                if v:ComputeAdjacentConnectionHeightChange(l) < -150 then 
                    v:Disconnect(l)
                end
    
            end
        end
        print("Navmesh has been edited to help with pathfinding!")

        navmesh.Save()
    end


    concommand.Add("glacebase_autoeditnav", GlaceBase_AutoEditNavmesh)
    concommand.Add("glacebase_kickbots", GlaceBase_KickAllBots)

end


-- Prints a message in console only if debug is on
function GlaceBase_DebugPrint(...)
    if GetConVar("glacebase_debug"):GetBool() then
        print("Glace Base: ",...)
    end
end


