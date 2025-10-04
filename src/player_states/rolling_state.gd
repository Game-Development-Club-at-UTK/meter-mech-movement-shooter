extends State
class_name RollingState


# Needs HEAVY tuning
func proc(player: Player, delta):
	if player.is_on_floor():
		player.velocity -= player.velocity.normalized() * player.roll_decel * delta
	if player.velocity.length() < player.run_speed * delta:
		player.velocity = player.velocity.normalized() * player.run_speed * delta
	
	if not Input.is_action_pressed("jump"):
		return player.IN_AIR_STATE

	return super(player, delta)
