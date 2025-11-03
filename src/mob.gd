extends CharacterBody3D

# attack range, rotation_speed, speed
@export var speed: float = 100.0
@export var detection_range: float = 1.0
@export var attack_range: float = 50.0 # for future will change based off enemy
@export var rotation_speed: float = 25.0

@export var attack_damage: float = 10.0
@export var cooldown: float = 1.5

#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5

# Reference to player
var player: Node3D = null
var is_chasing: bool = false
var is_attacking: bool = false
var gravity: float = 9.8

func _ready():
	# storing the player node
	player = get_tree().get_first_node_in_group("player")
	if player == null: # if player not present, can't start game
		push_warning("Player not found! Add player to 'player' group")

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player == null:
		return # player not present

	# check if player distance is in range of enemy)
	var distance_to_player = global_position.distance_to(player.global_position)
	print(distance_to_player)
	if distance_to_player <= detection_range:
		# start following & attacking player
		is_chasing = true
	elif distance_to_player > detection_range:
		is_chasing = false

	if is_chasing:
		chase_player(delta)	

func chase_player(delta):
	# Step 1: get direction of player
	var player_position = player.global_position
	var direction = player_position - global_position # in (x, y, z) coordinates
	direction.y = 0 # only accounting for vertical movement right now
	direction = direction.normalized() # assigns magnitude 1 to the coordinates
	var distance = global_position.distance_to(player_position)
	
	# Step 2: Check if player out of attack range
	print(distance)
	if distance <= attack_range:
		velocity.x = 0
		velocity.z = 0
		attack()
	elif distance > attack_range:
		# Step 2a: move towards player
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		# Step 2b: rotate to face player
		var target_rotation_y = atan2(direction.x, direction.z)
		var target_rotation_x = -asin(direction.y)
		
		rotation.x = lerp_angle(rotation.x, target_rotation_x, rotation_speed * delta)
		rotation.y = lerp_angle(rotation.y, target_rotation_y, rotation_speed * delta)
	
	# Step 3: if in attack range attack player
	# - call attack function
var time_last_att: float = 0.0
func attack():
	# attack logic
	time_last_att += get_physics_process_delta_time() # time tracker
	if time_last_att >= cooldown:
		time_last_att = 0.0