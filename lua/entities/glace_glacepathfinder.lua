AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT._IsGlacePathfinder = true
ENT.cornerchecktbls = {}
local TraceHull = util.TraceHull


function ENT:Initialize()
    if CLIENT then return end
    self:SetModel("models/player/kleiner.mdl")
    self:SetNoDraw(!GetConVar("developer"):GetBool())
    self:SetCollisionBounds(self.GlaceOwner:GetCollisionBounds())
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self:SetSolidMask( MASK_SOLID_BRUSHONLY )
    self.loco:SetStepHeight(25)

    self.loco:SetDesiredSpeed( !self.GlaceOwner:Glace_IsSprinting() and self.GlaceOwner:GetWalkSpeed()+2 or self.GlaceOwner:GetRunSpeed()+2 )
    self.loco:SetAvoidAllowed(true)
    self.loco:SetAcceleration(400)
end


function ENT:WalkDir(dir)
    local time = CurTime()+0.1
    while true do
        if CurTime() > time then break end
        local direction =  self:GetPos()+(self:GetPos()-dir):Angle():Forward()*100
        debugoverlay.Sphere(direction,6,0.2,Color(100,100,100),true)
        --Entity(1):SetPos(direction)
        self.loco:FaceTowards(direction)
        self.loco:Approach(direction, 1)
        --self.loco:Approach(direction,1)
        coroutine.yield()
    end
end

function ENT:MoveDir(dir)
    local time = CurTime()+0.1
    while true do
        if CurTime() > time then break end
        local direction =  (self:GetPos()+dir)
        debugoverlay.Sphere(direction,6,0.2,Color(100,100,100),true)
        --Entity(1):SetPos(direction)
        self.loco:FaceTowards(direction)
        self.loco:Approach(direction, 1)
        --self.loco:Approach(direction,1)
        coroutine.yield()
    end
end

function ENT:Avoid() -- Code borrowed from Zeta Players. Made to try and avoid stuff
    if self.TypingInChat then return end
    
    local nw,ne,sw,se = self:CornerCheck()

    if nw.Hit and ne.Hit then self:MoveDir(self:GetForward()*-50)

    elseif sw.Hit and se.Hit then self:MoveDir(self:GetForward()*50)

    elseif nw.Hit and sw.Hit then self:MoveDir(self:GetRight()*-50)

    elseif ne.Hit and se.Hit then self:MoveDir(self:GetRight()*50)

    elseif nw.Hit then self:WalkDir(nw.HitPos)

    elseif ne.Hit then self:WalkDir(ne.HitPos)

    elseif sw.Hit then self:WalkDir(sw.HitPos)

    elseif se.Hit then self:WalkDir(se.HitPos)

    end
end


function ENT:CornerCheck() -- Check the corners
    local hullmins,hullmaxs = self:GetCollisionBounds()
    hullmaxs[3] = 0
    hullmins[3] = 0
    local collmins,collmaxs = self:GetCollisionBounds()
    collmins[1] = collmins[1]/2
    collmins[2] = collmins[2]/2
    collmaxs[1] = collmaxs[1]/2
    collmaxs[2] = collmaxs[2]/2
    collmaxs[3] = 40

    debugoverlay.Box( self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20), collmins, collmaxs,0,Color(255,255,255,100))
    debugoverlay.Box( self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20), collmins, collmaxs,0,Color(255,255,255,100))
    debugoverlay.Box( self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20), collmins, collmaxs,0,Color(255,255,255,100))
    debugoverlay.Box( self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20), collmins, collmaxs,0,Color(255,255,255,100))

    debugoverlay.Text( self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20), 'NW', 0)
    debugoverlay.Text( self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20), 'NE', 0)
    debugoverlay.Text( self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20), 'SW', 0)
    debugoverlay.Text( self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20), 'SE', 0)

    self.cornerchecktbls.start = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.endpos = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.mins = collmins
    self.cornerchecktbls.maxs = collmaxs
    self.cornerchecktbls.filter = {self,self.GlaceOwner}
    local tr1 = TraceHull(self.cornerchecktbls)

    self.cornerchecktbls.start = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.endpos = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.mins = collmins
    self.cornerchecktbls.maxs = collmaxs
    self.cornerchecktbls.filter = {self,self.GlaceOwner}

    local tr2 = TraceHull(self.cornerchecktbls)

    self.cornerchecktbls.start = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.endpos = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.mins = collmins
    self.cornerchecktbls.maxs = collmaxs
    self.cornerchecktbls.filter = {self,self.GlaceOwner}

    local tr3 = TraceHull(self.cornerchecktbls)

    self.cornerchecktbls.start = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.endpos = self:GetPos()+Vector(-hullmaxs.x,-hullmaxs.y,20)
    self.cornerchecktbls.mins = collmins
    self.cornerchecktbls.maxs = collmaxs
    self.cornerchecktbls.filter = {self,self.GlaceOwner}

    local tr4 = TraceHull(self.cornerchecktbls)

return tr1,tr2,tr3,tr4

--[[ return util.TraceHull({start = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20),endpos = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20),mins = collmins,maxs = collmaxs,filter = {self,self.PhysgunnedENT,self.GrabbedENT}}),
util.TraceHull({start = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20),endpos = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20),mins = collmins,maxs = collmaxs,filter = {self,self.PhysgunnedENT,self.GrabbedENT}}),
util.TraceHull({start = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20),endpos = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20),mins = collmins,maxs = collmaxs,filter = {self,self.PhysgunnedENT,self.GrabbedENT}}),
util.TraceHull({start = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20),endpos = self:GetPos()+Vector(-hullmaxs.x,-hullmaxs.y,20),mins = collmins,maxs = collmaxs,filter = {self,self.PhysgunnedENT,self.GrabbedENT}})
 ]]
end



function ENT:MoveToPos() -- Basic move to position or follow entity code
    if !IsValid( self.GlaceOwner ) then return end
    if isentity( self.MovePos ) and !IsValid( self.MovePos ) then return end
    if !self.MovePos then return end

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( self.LookAhead or 100 )
	path:SetGoalTolerance( self.Goaltol or 50 )
	path:Compute( self, isentity( self.MovePos ) and self.MovePos:GetPos() or self.MovePos, self.GlaceOwner:PathfindFunction( self.loco ) ) -- We check if the position is a entity or not

	if ( !path:IsValid() ) then return "failed" end
    if !IsValid( self.GlaceOwner ) then return end

    self.GlaceOwner._GlaceIsMoving = true

	while ( path:IsValid() ) do
        if !IsValid( self.GlaceOwner ) then return end
        if isentity( self.MovePos ) and !IsValid( self.MovePos ) then self.GlaceOwner._GlaceIsMoving = false return "failed" end



        if GetConVar( "developer" ):GetBool() then
		    path:Draw()
        end

        self:Avoid()


		if ( self.loco:IsStuck() ) then

			self:HandleStuck()

			return "stuck"

		end


		if ( self.UpdateRate and path:GetAge() > self.UpdateRate ) then path:Compute( self, isentity( self.MovePos ) and self.MovePos:GetPos() or self.MovePos, self.GlaceOwner:PathfindFunction(self.loco) ) end


        path:Update( self )


		coroutine.yield()

	end

    if IsValid( self.GlaceOwner ) then

        self.GlaceOwner._GlaceIsMoving = false

    end

	return "ok"
end

function ENT:RemoveDB()
    --GlaceBase_DebugPrint(self.GlaceOwner," Pathfinder was removed \n"..debug.traceback())
    self:Remove()
end

function ENT:HandleStuck()
    if IsValid(self.GlaceOwner) then
        self.GlaceOwner._GlaceIsMoving = false
    end
    GlaceBase_DebugPrint("Pathfinder stuck")
    self:RemoveDB()
end

function ENT:Think()
    if CLIENT then return end
    

    if ( !IsValid( self.GlaceOwner ) or self.GlaceOwner._GlaceAbortMove ) or IsValid( self.GlaceOwner ) and !self.GlaceOwner:Alive() then

        if IsValid( self.GlaceOwner ) then
            self.GlaceOwner._GlaceAbortMove = false
            self.GlaceOwner._GlaceIsMoving = false
        end

        self:RemoveDB()
        return
    end

    if self:GetRangeSquaredTo( self.GlaceOwner ) >= ( 200 * 200 ) then -- Too far away
        self:RemoveDB()
    end

end

function ENT:RunBehaviour()

    self:MoveToPos()

    if self.ShouldWaitForOwner then -- Wait until our player gets near us or if they take too long

        local timeout = CurTime()+3
        while IsValid( self.GlaceOwner ) and self.GlaceOwner:Alive() do 
            self.Goaltol = self.Goaltol or 50
            if self:GetRangeSquaredTo(self.GlaceOwner) <= (self.Goaltol*self.Goaltol) or CurTime() > timeout then break end
            coroutine.wait(0.5)
        end

    end

    if IsValid(self.GlaceOwner) then self.GlaceOwner._GlaceIsMoving = false end

    self:RemoveDB()

end