

EFFECT.Mat = Material("effects/laser1.vmt")

--[[---------------------------------------------------------
   Init( data table )
-----------------------------------------------------------]]
function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()

	-- Keep the start and end pos - we're going to interpolate between them
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()

	self.Alpha = 255
	self.Life = 0.0;

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

end

--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )

	self.Life = self.Life + FrameTime() * 4;
	self.Alpha = 255 * ( 1 - self.Life )

	return (self.Life < 1)

end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render( )

	if ( self.Alpha < 1 ) then return end

	render.SetMaterial( self.Mat )
	local texcoord = math.Rand( 0, 1 )

	local norm = (self.StartPos - self.EndPos) * self.Life

	self.Length = norm:Length()


	for i=1, 3 do

		render.DrawBeam( self.StartPos - norm,										-- Start
					 self.EndPos,											-- End
					 64 * (1 - self.Life),													-- Width
					 texcoord,														-- Start tex coord
					 texcoord + self.Length / 128,									-- End tex coord
					 Color( Lerp(self.Life, 255, 50), Lerp(self.Life, 100, 50), 255, 255 ) )		-- Color (optional)
	end

	render.DrawBeam( self.StartPos,
						self.EndPos,
						64 * (1 - self.Life),
						texcoord,
						texcoord + ((self.StartPos - self.EndPos):Length() / 128),
						Color( Lerp(self.Life, 255, 50), Lerp(self.Life, 100, 50), 255, 255 )	)

end
