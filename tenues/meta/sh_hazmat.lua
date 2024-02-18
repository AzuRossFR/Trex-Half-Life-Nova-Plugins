local playerMeta = FindMetaTable("Player")

function playerMeta:HasHazmat()
    if self:GetCharacter() == nil then return false end
    
    local slot = self:GetCharacter():GetEquipment()

    if slot:HasItem("tenuepc") ~= false or
       slot:HasItem("hazmat_secu") ~= false or
       slot:HasItem("hazmat_dist") ~= false or
       slot:HasItem("hazmat_cher") ~= false then

        if slot:HasItem("tenuepc") and slot:HasItem("tenuepc"):GetData("equip", false) == true or
           slot:HasItem("hazmat_secu") and slot:HasItem("hazmat_secu"):GetData("equip", false) == true or
           slot:HasItem("hazmat_dist") and slot:HasItem("hazmat_dist"):GetData("equip", false) == true or
           slot:HasItem("hazmat_cher") and slot:HasItem("hazmat_cher"):GetData("equip", false) == true then
            return true
        else
            return false
        end
    end
    
    return false
end
