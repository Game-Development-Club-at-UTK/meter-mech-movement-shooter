extends CharacterBody3D

@export var target_position: Vector3
@export var speed: float = 1.9
@export var baseSpeed: float = 1.9 #the original speed, used in case speed gets modified
var pitch: float
var yaw : float
@export var randomWalk = true
@export var lookTargetNode : Node3D

@onready var idle_state = $IdleState #idle behavior
@onready var walk_state = $walkState #random walk behavior
@onready var timer = $Timer #temporary timer used to control idle/walk behavior


var current_state: State


#animation variables. updated in physics_process
@onready var animTree = $AnimationPlayer/AnimationTree
@onready var turning : bool #whether we're waling along the ground
var previousRotationY : float #used to determine whether we're rotating along the y axis
var currentRotationY : float
@onready var walking : bool #whether we're standing still and turning
@onready var active : bool #just used to make sure state machine activates

func _ready():
	randomize()
	timer.timeout.connect(_on_timer_timeout)
	switch_state(idle_state)
	timer.start(2.0)
	
	#make sure all animation variables start with a value
	active = true
	walking = false
	turning = false
	previousRotationY = rotation.y
	animTree.active = true
	

	
func _physics_process(delta):
	if current_state:
		current_state.update(delta)
		
	#update animation variables
	if(velocity.length() > 0):
		if(!walking):
			walking = true
	else:
		if(walking):
			walking = false
		
	
	currentRotationY = rotation.y
	
	if(abs(currentRotationY - previousRotationY) > 0):
		if(!turning):
			turning = true
	else:
		if(turning):
			turning = false
	
	#set aimoffset variables


	animTree.set("parameters/aimBlendSpace/blend_position", Vector2(pitch,yaw))
	

		
		
func switch_state(new_state: State):
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func _on_timer_timeout():
	if current_state == idle_state && randomWalk == true:
		switch_state(walk_state)
	timer.start(randf_range(1.5, 3.0))
