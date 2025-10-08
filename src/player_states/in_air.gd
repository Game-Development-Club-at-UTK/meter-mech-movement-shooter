extends WASDState
class_name InAirState


func proc(player: Player, delta):
	if player.is_on_floor():
		return player.GROUNDED_STATE

	if Input.is_action_just_pressed("jump") and player.DASHING_STATE.cooldown.is_stopped():
		return player.DASHING_STATE;

	return super(player, delta)
