
-- VERSION 2.0 released 03/26/2017
-- Changes: 
--   1.	Half as many polygons per arc
--   2.	Only one loop for inner and outer points
--   3.	Uses quads instead of triangles
--   4.	Odd-degreed arcs aren't malformed.
--   5.	No longer needs roughness. Just put 1 in case of old version conflicts.
--   6.	Microoptimizations.
-- Enjoy! ~Bobbleheadbob

-- Draws an arc on your screen.
-- startang and endang are in degrees, 
-- radius is the total radius of the outside edge to the center.
-- cx, cy are the x,y coordinates of the center of the arc.
-- roughness is only used in old versions. Just put 1 to prevent conflicts
local cos, sin, abs, max, rad1, log, pow = math.cos, math.sin, math.abs, math.max, math.rad, math.log, math.pow
local surface = surface

local function DrawArc(arc) -- Draw a premade arc.
	for k,v in ipairs(arc) do
		surface.DrawPoly(v)
	end
end

local function PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness)
	local quadarc = {}
	
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	
	-- Define step
	-- roughness = roughness or 1
	local diff = abs(startang-endang)
	local smoothness = log(diff,2)/2
	local step = diff / (pow(2,smoothness))
	if startang > endang then
		step = abs(step) * -1
	end
	
	-- Create the inner circle's points.
	local inner = {}
	local outer = {}
	local ct = 1
	local r = radius - thickness
	
	-- :D
	step = 5;
	for deg=startang, endang, step do
		local rad = rad1(deg)
		-- local rad = deg2rad * deg
		local cosrad, sinrad = cos(rad), sin(rad) --calculate sin,cos
		
		local ox, oy = cx+(cosrad*r), cy+(-sinrad*r) --apply to inner distance
		inner[ct] = {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		}
		
		local ox2, oy2 = cx+(cosrad*radius), cy+(-sinrad*radius) --apply to outer distance
		outer[ct] = {
			x=ox2,
			y=oy2,
			u=(ox2-cx)/radius + .5,
			v=(oy2-cy)/radius + .5,
		}
		
		ct = ct + 1
	end
	
	-- QUAD the points.
	for tri=1,ct do
		local p1,p2,p3,p4
		local t = tri+1
		p1=outer[t]
		p2=outer[tri]
		p3=inner[tri]
		p4=inner[t]
		
		quadarc[tri] = {p1,p2,p3,p4}
	end
	
	-- Return a table of triangles to draw.
	return quadarc
	
end

function SublimeUI.Arc(cx,cy,radius,thickness,startang,endang,roughness,color)
	surface.SetDrawColor(color)
	DrawArc(PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness))
end