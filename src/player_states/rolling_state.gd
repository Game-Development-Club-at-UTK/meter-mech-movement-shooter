extends State
class_name RollingState

var strafe_disp: Vector3
var strafe_dir: Vector3


func proc(player: Player, delta):
	# Undo displacement due to strafe from previous call
	player.velocity -= strafe_disp

	if player.is_on_floor():
		player.velocity -= player.velocity.normalized() * player.roll_decel * delta
	if player.velocity.length() < player.run_speed * delta:
		player.velocity = player.velocity.normalized() * player.run_speed * delta
	
	strafe_disp = strafe_dir * player.roll_strafe * Input.get_axis("right", "left") * delta
	player.velocity += strafe_disp
	
	if not Input.is_action_pressed("jump"):
		return player.IN_AIR_STATE

	return super(player, delta)


func on_enter(player: Player):
	strafe_disp = Vector3(0, 0, 0)
	strafe_dir = (player.velocity - Vector3(0, player.velocity.y, 0)).normalized().rotated(Vector3(0, 1, 0), PI/2)
