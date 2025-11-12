extends WASDState
class_name InAirState


func proc(player: Player, delta):
	if player.is_on_floor():
		player.camera.trauma += 0.1
		return player.GROUNDED_STATE

	if Input.is_action_just_pressed("jump") and player.DASHING_STATE.cooldown.is_stopped():
		player.camera.trauma += 0.2
		return player.DASHING_STATE;

	return super(player, delta)
