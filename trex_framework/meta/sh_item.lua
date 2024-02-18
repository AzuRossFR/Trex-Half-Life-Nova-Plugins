local ITEM = ix.meta.item

function ITEM:GetName()
	return (self.PrintName and (CLIENT and L(self.PrintName) or self.PrintName)) or (CLIENT and L(self.name) or self.name)
end

function ITEM:Register()
	return ix.item.Register2(self)
end

ix.meta.item = ITEM
