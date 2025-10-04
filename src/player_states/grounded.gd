extends WASDState
class_name GroundedState


func proc(player: Player, delta):
	if player.is_on_floor() and Input.is_action_pressed("jump"):
		player.velocity.y = player.jump_force
		player.heat += 15.0
		return player.IN_AIR_STATE

	return super(player, delta)

