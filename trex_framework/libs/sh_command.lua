function ix.command.FindByID(identifier)
    identifier = string.lower(identifier)

    if (identifier:sub(1, 1) == "/") then
        identifier = identifier:sub(2)
    end

    if(ix.command.list[identifier]) then
        return ix.command.list[identifier]
    end

	return {}
end