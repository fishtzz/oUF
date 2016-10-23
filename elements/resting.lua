--[[ Element: Resting Icon

 Toggles visibility of the resting icon.

 Widget

 Resting - Any UI widget.

 Notes

 The default resting icon will be used if the UI widget is a texture and doesn't
 have a texture or color defined.

 Examples

   -- Position and size
   local Resting = self:CreateTexture(nil, 'OVERLAY')
   Resting:SetSize(16, 16)
   Resting:SetPoint('TOPLEFT', self)

   -- Register it with oUF
   self.Resting = Resting

 Hooks

 Override(self) - Used to completely override the internal update function.
                  Removing the table key entry will make the element fall-back
                  to its internal function again.
]]

local parent, ns = ...
local oUF = ns.oUF

local function Update(self, event)
	local element = self.Resting
	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local isResting = IsResting()
	if(isResting) then
		element:Show()
	else
		element:Hide()
	end

	if(element.PostUpdate) then
		return element:PostUpdate(isResting)
	end
end

local function Path(self, ...)
	return (self.Resting.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self, unit)
	local element = self.Resting
	if(element and unit == 'player') then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('PLAYER_UPDATE_RESTING', Path, true)

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
			element:SetTexCoord(0, 0.5, 0, 0.421875)
		end

		return true
	end
end

local function Disable(self)
	local element = self.Resting
	if(element) then
		element:Hide()

		self:UnregisterEvent('PLAYER_UPDATE_RESTING', Path)
	end
end

oUF:AddElement('Resting', Path, Enable, Disable)
