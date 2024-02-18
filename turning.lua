PLUGIN.name = "Meilleure ANIMS"
PLUGIN.author = "Trex"


local whitelist = {
	[ACT_MP_STAND_IDLE] = true,
	[ACT_MP_CROUCH_IDLE] = true
}

function PLUGIN:TranslateActivity(client, act)

	if not whitelist[act] then
		return
	end

	client.NextTurn = client.NextTurn or 0

	local diff = math.NormalizeAngle(client:GetRenderAngles().y - client:EyeAngles().y)

	if math.abs(diff) >= 45 and client.NextTurn <= CurTime() then
		local gesture = diff > 0 and ACT_GESTURE_TURN_RIGHT90 or ACT_GESTURE_TURN_LEFT90

		if gesture == ACT_GESTURE_TURN_LEFT90 then
			gesture = ACT_GESTURE_TURN_LEFT45
		end

		client:AnimRestartGesture(GESTURE_SLOT_CUSTOM, gesture, true)
		client.NextTurn = CurTime() + client:SequenceDuration(client:SelectWeightedSequence(gesture))
	end
end
