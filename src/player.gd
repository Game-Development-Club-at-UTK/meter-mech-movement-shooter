extends CharacterBody3D
class_name Player


@export_group("Movement")
@export var run_speed = 600.0
@export var jump_force = 10.0
@export var gravity = 20.0
@export_subgroup("Dashing")
@export var dash_speed = 1200.0
@export var dash_length = 5.0
@export var dash_cooldown = 0.5
@export_subgroup("Rolling")
@export var roll_decel = 200.0
@export var roll_strafe = 200.0

@export_group("Heat")
@export var max_heat = 100.0
@export var heat_loss = 5.0
@export var run_heat_gain = 10.0
@export var jump_heat_gain = 15.0
@export var dash_heat_gain = 25.0

@export_group("", "")
@export var mouse_sensitivity = 0.002
@export var max_health = 100.0
@export var bullet_scene : PackedScene

static var GROUNDED_STATE = GroundedState.new()
static var IN_AIR_STATE = InAirState.new()
static var DASHING_STATE = DashingState.new()
static var ROLLING_STATE = RollingState.new()

var health = max_health
var heat = 0.0
var frame_timer = 0.0
var current_state: State = IN_AIR_STATE
var current_look_direction = Vector3(0,0,0)


func _ready():
	GROUNDED_STATE.name = "GroundedState"
	add_child(GROUNDED_STATE)
	IN_AIR_STATE.name = "InAirState"
	add_child(IN_AIR_STATE)
	DASHING_STATE.name = "DashingState"
	add_child(DASHING_STATE)
	DASHING_STATE.create_timers(self)
	ROLLING_STATE.name = "RollingState"
	add_child(ROLLING_STATE)

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

	move_and_slide()

	#firing
	if Input.is_action_pressed("fire1"):
		self.heat -= 25.0 * delta
		if (int(frame_timer * 60.0) % 5) == 0: #ensures we only fire every 3rd frame
			current_look_direction = ($Camera3D/lookPositionHint.global_position - $Camera3D.global_position).normalized()
			self.add_child(bullet_scene.instantiate())

	#heat bar management
	if heat > max_heat:
		print("overheating")
	else:
		heat -= heat_loss * delta
	heat = clampf(heat, 0.0, max_heat)
	$"../UI/ProgressBar".value = lerpf($"../UI/ProgressBar".value, heat, .2)
	$"../UI/ProgressBar2".value = lerpf($"../UI/ProgressBar2".value, heat, .2)
