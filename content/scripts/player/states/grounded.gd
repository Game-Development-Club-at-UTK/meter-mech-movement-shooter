extends WASDState
class_name GroundedState


func proc(player: Player, delta):
	if player.is_on_floor() and Input.is_action_pressed("jump"):
		player.velocity.y = player.jump_force
		player.heat += player.jump_heat_gain
		return player.IN_AIR_STATE
	player.velocity.x -= player.velocity.x * 0.25 * delta * 60 
	player.velocity.z -= player.velocity.z * 0.25 * delta * 60

	return super(player, delta)
