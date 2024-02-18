PANEL = {}

local function SawTooth(freq, offset, min, max)
	return max - (((CurTime() * freq) + offset) % 1) * (max - min)
end

local function DrawCenteredRect(x, y, width, height)
	surface.DrawRect(x - width * 0.5, y - height * 0.5, width, height)
end

function PANEL:Init()
	self.color = color_white
	self.freq = 1
end

function PANEL:SetColor(col)
	self.color = col
end

function PANEL:SetFrequency(freq)
	self.freq = tonumber(freq) or 1
end

function PANEL:SetLarge(bLarge)
	self.bLarge = tobool(bLarge)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(self.color)

	if (!self.bLarge) then
		local cubeSize = w * 0.5
		-- Top left
		local curve = SawTooth(self.freq, 0.75, cubeSize * 0.25, cubeSize)

		DrawCenteredRect(w * 0.25, h * 0.25, curve, curve)

		-- Top right
		curve = SawTooth(self.freq, 0.5, cubeSize * 0.25, cubeSize)

		DrawCenteredRect(w * 0.75, h * 0.25, curve, curve)

		-- Bottom right
		curve = SawTooth(self.freq, 0.25, cubeSize * 0.25, cubeSize)

		DrawCenteredRect(w * 0.75, h * 0.75, curve, curve)

		-- Bottom left
		curve = SawTooth(self.freq, 0, cubeSize * 0.25, cubeSize)

		DrawCenteredRect(w * 0.25, h * 0.75, curve, curve)
	else
		local curid = 0
		local cubeSize = (w * 0.25)

		for i = 0, 3 do
			if ((i + 1) % 2 == 0) then
				for ii = 3, 0, -1 do
					local size = SawTooth(self.freq, -(curid / 16), cubeSize / 3, cubeSize)
					local posx = ii * cubeSize + cubeSize * 0.5
					local posy = i * cubeSize + cubeSize * 0.5

					DrawCenteredRect(posx, posy, size, size)

					curid = curid + 1
				end
			else
				for ii = 0, 3 do
					local size = SawTooth(self.freq, -(curid / 16), cubeSize / 3, cubeSize)
					local posx = ii * cubeSize + cubeSize * 0.5
					local posy = i * cubeSize + cubeSize * 0.5

					DrawCenteredRect(posx, posy, size, size)

					curid = curid + 1
				end
			end
		end
	end
end

vgui.Register("ixHelixSpinner", PANEL)