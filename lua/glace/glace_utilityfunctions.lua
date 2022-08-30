
if SERVER then



    function GlaceBase_KickAllBots()

        for k, v in ipairs( player.GetBots() ) do
            v:Kick()
        end

    end


    concommand.Add("glacebase_kickbots", GlaceBase_KickAllBots)

end


-- Prints a message in console only if debug is on
function GlaceBase_DebugPrint(...)
    if GetConVar("glacebase_debug"):GetBool() then
        print("Glace Base: ",...)
    end
end


