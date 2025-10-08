@abstract
extends State
class_name WASDState

var is_movement_input = false


func proc(player: Player, delta):
	var h_velocity = Vector3()

	is_movement_input = false
	if Input.is_action_pressed("forward"):
		h_velocity += Vector3.FORWARD
		is_movement_input = true
	if Input.is_action_pressed("back"):
		h_velocity += Vector3.BACK
		is_movement_input = true
	if Input.is_action_pressed("left"):
		h_velocity += Vector3.LEFT
		is_movement_input = true
	if Input.is_action_pressed("right"):
		h_velocity += Vector3.RIGHT
		is_movement_input = true
	
	if is_movement_input:
		player.heat += player.run_heat_gain * delta
	
	h_velocity = h_velocity.normalized() * player.run_speed * delta
	h_velocity = h_velocity.rotated(Vector3(0.0, 1.0, 0.0), player.rotation.y)
	# Only apply h_velocity if it is smaller than current horizontal velocity
	if player.velocity.project(Vector3(1, 0, 1)).length() < h_velocity.length():
		player.velocity.x = h_velocity.x
		player.velocity.z = h_velocity.z

	return super(player, delta)
