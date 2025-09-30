extends CharacterBody3D
class_name Player


@export var run_speed = 300.0
@export var dash_speed = 1200.0
@export var jump_force = 10.0
@export var gravity = 10.0
@export var mouse_sensitivity = 0.002
@export var max_health = 100.0
@export var fire_rate = 0.1
@export var damage = 2.0
@export var heat_gain = 0.01
@export var max_heat = 100.0
@export var heat_loss = 5.0
@export var dash_length = 5.0
@export var dash_heat_cost = 0.2
@export var bullet_scene : PackedScene

static var GROUNDED_STATE = GroundedState.new()
static var IN_AIR_STATE = InAirState.new()
static var DASHING_STATE = DashingState.new()

var health = max_health
var heat = 0.0
var frame_timer = 0.0
var current_state: State = IN_AIR_STATE
var is_movement_input = false
var current_look_direction = Vector3(0,0,0)


func _ready():
	GROUNDED_STATE.name = "GroundedState"
	add_child(GROUNDED_STATE)
	IN_AIR_STATE.name = "InAirState"
	add_child(IN_AIR_STATE)
	DASHING_STATE.name = "DashingState"
	add_child(DASHING_STATE)
	DASHING_STATE.create_timer(self)

	current_state.on_enter(self)

func _physics_process(delta):
	#timer management
	frame_timer += delta
	if frame_timer >= 1:
		frame_timer = 0
	
	var view_velocity = -Input.get_last_mouse_velocity() * mouse_sensitivity * delta
	rotation.y += view_velocity.x
	$Camera3D.rotation.x += view_velocity.y
	$Camera3D.rotation.x = clampf ($Camera3D.rotation.x, -PI/2, PI/2)


	# State machine
	# Do movement logic depending on current state, and transition to new states under certain conditions
	var new_state = current_state.proc(self, delta)
	if new_state is State:
		current_state.on_exit(self)
		current_state = new_state
		current_state.on_enter(self)

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
		heat += 10.0 * delta
	
	h_velocity = h_velocity.normalized() * run_speed * delta
	h_velocity = h_velocity.rotated(Vector3(0.0, 1.0, 0.0), rotation.y)
	velocity.x = h_velocity.x
	velocity.z = h_velocity.z
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_force
		heat += 25

	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()

	#firing
	if Input.is_action_pressed("fire1"):
		self.heat -= 25.0 * delta
		if (int(frame_timer * 60.0) % 5) == 0: #ensures we only fire every 3rd frame
			current_look_direction = ($Camera3D/lookPositionHint.global_position - $Camera3D.global_position).normalized()
			self.add_child(bullet_scene.instantiate())

	#venting
	if Input.is_action_just_pressed("vent"):
		pass

	#heat bar management
	if heat > max_heat:
		print("overheating")
		heat = max_heat
	if heat < 0:
		heat = 0
	else:
		heat -= heat_loss * delta
	$"../UI/ProgressBar".value = lerpf($"../UI/ProgressBar".value, heat, .2)
	$"../UI/ProgressBar2".value = lerpf($"../UI/ProgressBar2".value, heat, .2)
