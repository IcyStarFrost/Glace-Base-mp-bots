

local meta = FindMetaTable("Panel")
local oldfunc = meta.SetPlayer


function meta:SetPlayer(ply, size)
    if !IsValid(ply) or !ply:IsPlayer() then return end

    if ply:GetNW2Bool( "glacebase_isglaceplayer", false ) then

        -- Get the Profile Picture
        ply._GlaceBasePfpCache = ply._GlaceBasePfpCache or Material("glacebase/profilepictures/"..ply:GetNW2String("glacebase_profilepicture","default.png")) 

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