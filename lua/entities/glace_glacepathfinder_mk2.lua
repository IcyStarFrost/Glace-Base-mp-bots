AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT._IsGlacePathfinder = true



function ENT:Initialize()
    if CLIENT then return end
    self:SetModel("models/player/kleiner.mdl")
    self:SetNoDraw(!GetConVar("developer"):GetBool())
    self:SetCollisionBounds(self.GlaceOwner:GetCollisionBounds())
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self:SetSolidMask( MASK_SOLID_BRUSHONLY )

end




function ENT:ComputePath( pos, lookahead, tol )
    local owner = self.GlaceOwner

    if !pos or !IsValid( owner ) then return end

    local path = Path( "Follow" )

    path:SetMinLookAheadDistance( lookahead or 100 )
    path:SetGoalTolerance( tol or 50 )

    path:Compute( self, isentity( pos ) and pos:GetPos() or pos, owner:PathfindFunction(self.loco))

    if IsValid( path ) then
        return path
    end

end

function ENT:Think()
    if CLIENT then return end
    

    if ( !IsValid( self.GlaceOwner ) or self.GlaceOwner._GlaceAbortMove ) or ( IsValid( self.GlaceOwner ) and !self.GlaceOwner:Alive() ) then

        if IsValid( self.GlaceOwner ) then
            self.GlaceOwner._GlaceAbortMove = false
            self.GlaceOwner._GlaceIsMoving = false
        end

        self:Remove()
        return
    end

end

function ENT:RunBehaviour()

    while true do 

        coroutine.wait(5)
    end

end