extends CharacterBody3D

@export var data : enemyData
var target_position : Vector3
@export var speed : float = 1.9
@export var baseSpeed: float = 1.9 #the original speed, used in case speed gets modified
@export var randomWalk = true
@export var lookTargetNode : Node3D
@onready var idle_state = $IdleState #idle behavior
@onready var walk_state = $walkState #random walk behavior
@onready var timer = $Timer #temporary timer used to control idle/walk behavior


var current_state: enemyState


#animation variables. updated in physics_process
var pitch : float
var yaw : float
var desiredPitch : float
var desiredYaw : float
var rot : float #for rotating arms. we only need one angle
var desiredRot : float
@onready var animTree = $AnimationPlayer/AnimationTree
@onready var turning : bool #whether we're waling along the ground
var previousRotationY : float #used to determine whether we're rotating along the y axis
var currentRotationY : float
@onready var walking : bool #whether we're standing still and turning
@onready var active : bool #just used to make sure state machine activates
@export var eyePosition : Node3D
@export var leftArmPos : Node3D
@export var rightArmPos : Node3D

#to be used when we destroy appendages
@onready var skeleton = $mesh/Armature/Skeleton3D
	
	
func destroy_bone(bone : String):
	var bone_idx = skeleton.find_bone(bone)
	if(bone_idx != -1) : #error checking
		var zero_scale_basis := Basis(Vector3.ZERO, Vector3.ZERO, Vector3.ZERO)
		var boneTransform = Transform3D(zero_scale_basis, Vector3.ZERO)
		skeleton.set_bone_global_pose(bone_idx, boneTransform)
	else :
		print("bone index invalid")


func _ready():
	pitch = 0
	yaw = 0
	rot = 0
	#just testing
	#destroy_bone("L_arm")
	
	#set up timer for switching states
	randomize()
	timer.timeout.connect(_on_timer_timeout)
	switch_state(idle_state)
	timer.start(2.0)
	
	#make sure all animation variables start with a value
	active = true
	walking = false
	turning = false
	previousRotationY = global_rotation.y
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
		

	#rotate toward the desired yaw and pitch smoothly, at [turn_rate] degrees per second
	if(desiredYaw > yaw) : yaw += data.turn_rate * delta 
	if(desiredYaw < yaw) : yaw -= data.turn_rate * delta 
	if(desiredPitch > pitch) : pitch += data.turn_rate * delta 
	if(desiredPitch < pitch) : pitch -= data.turn_rate * delta 
	if(desiredRot < rot) : rot -= data.turn_rate * delta
	if(desiredRot > rot) : rot += data.turn_rate * delta
	
	currentRotationY = global_rotation.y
	
	#rotate torso at double speed if we're turning legs as well
	if(abs(currentRotationY - previousRotationY) != 0):
			turning = true
			if(desiredYaw > yaw) : yaw += data.turn_rate * delta 
			if(desiredYaw < yaw) : yaw -= data.turn_rate * delta 
	else:
			turning = false
	previousRotationY = currentRotationY
	
	#set aimoffset variables
	animTree.set("parameters/aimBlendSpace/blend_position", Vector2(yaw,pitch))
	animTree.set("parameters/BlendSpace1D/blend_position", rot)
	

		
		
func switch_state(new_state: enemyState):
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func _on_timer_timeout():
	if current_state == idle_state && randomWalk == true:
		switch_state(walk_state)
	timer.start(randf_range(5, 8))
