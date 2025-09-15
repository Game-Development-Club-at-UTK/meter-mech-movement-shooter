extends CharacterBody3D
class_name Player


@export var run_speed = 300.0
@export var jump_force = 10.0
@export var gravity = 30.0
@export var mouse_sensitivity = 0.005


# It might be a good idea to replace most of this movement code with a state machine later on
func _physics_process(delta):
	var view_velocity = -Input.get_last_mouse_velocity() * mouse_sensitivity * delta
	rotation.y += view_velocity.x
	$Camera3D.rotation.x += view_velocity.y
	$Camera3D.rotation.x = clampf ($Camera3D.rotation.x, -PI/2, PI/2)

	var h_velocity = Vector3()

	if Input.is_action_pressed("forward"):
		h_velocity += Vector3.FORWARD
	if Input.is_action_pressed("back"):
		h_velocity += Vector3.BACK
	if Input.is_action_pressed("left"):
		h_velocity += Vector3.LEFT
	if Input.is_action_pressed("right"):
		h_velocity += Vector3.RIGHT
	
	h_velocity = h_velocity.normalized() * run_speed * delta
	h_velocity = h_velocity.rotated(Vector3(0.0, 1.0, 0.0), rotation.y)
	velocity.x = h_velocity.x
	velocity.z = h_velocity.z
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_force

	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()
