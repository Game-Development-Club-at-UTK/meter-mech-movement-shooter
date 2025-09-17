extends CharacterBody3D
class_name Player


@export var run_speed = 300.0
@export var dash_speed = 1200.0
@export var jump_force = 10.0
@export var gravity = 30.0
@export var mouse_sensitivity = 0.005
@export var max_health = 100.0
@export var fire_rate = 0.1
@export var damage = 2.0
@export var heat_gain = 0.01
@export var dash_length = 5.0
@export var dash_heat_cost = 0.2

static var GROUNDED_STATE = GroundedState.new()
static var IN_AIR_STATE = InAirState.new()
static var DASHING_STATE = DashingState.new()

var health = max_health
var heat = 0.0
var current_state: State = IN_AIR_STATE


func _ready():
	GROUNDED_STATE.name = "GroundedState"
	add_child(GROUNDED_STATE)
	IN_AIR_STATE.name = "InAirState"
	add_child(IN_AIR_STATE)
	DASHING_STATE.name = "DashingState"
	add_child(DASHING_STATE)
	DASHING_STATE.create_timer(self)

	current_state.on_enter(self)


# It might be a good idea to replace most of this movement code with a state machine later on
func _physics_process(delta):
	if Input.is_action_pressed("fire") and $FireCooldown.is_stopped():
		var collider = $RayCast3D.get_collider()
		if collider is Enemy:
			collider.health -= damage
		heat += heat_gain
		$FireCooldown.start(fire_rate)

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

	heat = clampf(heat, 0.0, 1.0)
