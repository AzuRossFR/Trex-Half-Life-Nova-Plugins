ix.entity = ix.entity or {}

if(SERVER) then

	function ix.entity.MakeFlushToSurface(entity, position, normal)
		entity:SetPos(position + (entity:GetPos() - entity:NearestPoint(position - (normal * 512))));
    end;

    function ix.entity.SetClient(entity, client)
		entity:SetNetworkedEntity("Client", client);
	end;
end