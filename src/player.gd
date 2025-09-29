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

var maxHeat = 100.0
var heatLoss = 5.0
var currentHeat = 0.0

var isMovementInput = false
var currentLookDirection = Vector3(0,0,0)
@export var bullet_scene : PackedScene
var frameTimer = 0.0

# It might be a good idea to replace most of this movement code with a state machine later on
func _physics_process(delta):

	if Input.is_action_pressed("fire") and $FireCooldown.is_stopped():
		var collider = $RayCast3D.get_collider()
		if collider is Enemy:
			collider.health -= damage
		heat += heat_gain
		$FireCooldown.start(fire_rate)


	#tiemr management
	frameTimer += delta
	if frameTimer >= 1:
		frameTimer = 0
	

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



	heat = clampf(heat, 0.0, 1.0)

	var h_velocity = Vector3()

	isMovementInput = false
	if Input.is_action_pressed("forward"):
		h_velocity += Vector3.FORWARD
		isMovementInput = true
	if Input.is_action_pressed("back"):
		h_velocity += Vector3.BACK
		isMovementInput = true
	if Input.is_action_pressed("left"):
		h_velocity += Vector3.LEFT
		isMovementInput = true
	if Input.is_action_pressed("right"):
		h_velocity += Vector3.RIGHT
		isMovementInput = true
	
	if isMovementInput:
		currentHeat += 10.0 * delta
	
	h_velocity = h_velocity.normalized() * run_speed * delta
	h_velocity = h_velocity.rotated(Vector3(0.0, 1.0, 0.0), rotation.y)
	velocity.x = h_velocity.x
	velocity.z = h_velocity.z
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_force
		currentHeat += 25

	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()

	#firing
	if Input.is_action_pressed("fire1"):
		self.currentHeat -= 25.0 * delta
		if (int(frameTimer * 60.0) % 5) == 0: #ensures we only fire every 3rd frame
			currentLookDirection = ($Camera3D/lookPositionHint.global_position - $Camera3D.global_position).normalized()
			self.add_child(bullet_scene.instantiate())

	#venting
	if Input.is_action_just_pressed("vent"):
		pass

	#heat bar management
	if currentHeat > maxHeat:
		print("overheating")
		currentHeat = maxHeat
	if currentHeat < 0:
		currentHeat = 0
	else:
		currentHeat -= heatLoss * delta
	$"../UI/ProgressBar".value = lerpf($"../UI/ProgressBar".value, currentHeat, .2)
	$"../UI/ProgressBar2".value = lerpf($"../UI/ProgressBar2".value, currentHeat, .2)

