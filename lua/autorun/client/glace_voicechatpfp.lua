
local meta = FindMetaTable("Panel")
local oldfunc = meta.SetPlayer

print("Glace: Voice chat PFP Set up")

function meta:SetPlayer(ply, size)
    if !IsValid(ply) or !ply:IsPlayer() then return end


    if ply.IsGlacePlayer then
        
        -- Get the Profile Picture
        local pfp = ply._GlaceProfilePicture or "default.png"

        ply._GlaceBasePfpCache = ply._GlaceBasePfpCache or Material( "glacebase/profilepictures/" .. pfp ) 

        function self:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255,0))
        end

        local background = vgui.Create("DPanel", self)
        background:Dock(FILL)

        function background:Paint(w, h)
            if !ispanel(self:GetParent()) then
                self:Remove()
                return
            end

            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255,0))
        end

        -- Create the panel that will show it
        local pfp = vgui.Create("DImage", self)
        pfp:Dock(FILL)

        pfp:SetMaterial(ply._GlaceBasePfpCache)



    else

        oldfunc(self, ply, size)

    end
end


net.Receive( "glacebase_dispatchpfp", function()
    local entity = net.ReadEntity()
    local pfp = net.ReadString()

    if IsValid( entity ) then
        
        entity._GlaceProfilePicture = pfp

    end
end )