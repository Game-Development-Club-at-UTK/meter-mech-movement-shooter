extends Node
class_name State


var has_gravity = true
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
		player.heat += 10.0 * delta
	
	h_velocity = h_velocity.normalized() * player.run_speed * delta
	h_velocity = h_velocity.rotated(Vector3(0.0, 1.0, 0.0), player.rotation.y)
	player.velocity.x = h_velocity.x
	player.velocity.z = h_velocity.z

	if not player.is_on_floor() and has_gravity:
		player.velocity.y -= player.gravity * delta
	
	# if Input.is_action_just_pressed("dash"):
	# 	return player.DASHING_STATE


func on_enter(_player: Player):
	pass


func on_exit(_player: Player):
	pass
