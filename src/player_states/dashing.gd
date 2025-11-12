extends State
class_name DashingState


var start_pos: Vector3
var direction: Vector3
var timer: Timer
var cooldown: Timer
var should_exit = false


func _ready():
	has_gravity = false

# Uuuuuhhhh add coyote time maybe???
func proc(player: Player, delta):
	if (player.position - start_pos).length() >= player.dash_length:
		should_exit = true

	if should_exit:
		if Input.is_action_pressed("jump"):
			return player.ROLLING_STATE
		else:
			return player.IN_AIR_STATE
	
	player.velocity += direction * player.dash_speed * delta
	player.velocity.y = 0.0
	return super(player, delta)


func on_enter(player: Player):
	start_pos = player.position
	direction = Vector3()
	should_exit = false

	if Input.is_action_pressed("back"):
		direction += Vector3.BACK
	if Input.is_action_pressed("left"):
		direction += Vector3.LEFT
	if Input.is_action_pressed("right"):
		direction += Vector3.RIGHT
	if Input.is_action_pressed("forward") or direction.length() == 0.0:
		direction += Vector3.FORWARD
	
	direction = direction.normalized()
	direction = direction.rotated(Vector3(0.0, 1.0, 0.0), player.rotation.y)
	assert(direction.length() != 0.0)

	timer.start()
	cooldown.start()

	player.heat += player.dash_heat_gain



# Create timers for dash cooldown and as a backup to exit the dashing state in case the player gets stuck
func create_timers(player: Player):
	timer = Timer.new()
	timer.name = "DashTimer"
	timer.timeout.connect(_on_timeout)
	timer.one_shot = true
	timer.wait_time = 100 * player.dash_length / player.dash_speed
	add_child(timer)
	cooldown = Timer.new()
	cooldown.name = "DashCooldown"
	cooldown.one_shot = true
	cooldown.wait_time = player.dash_cooldown
	add_child(cooldown)



func _on_timeout():
	should_exit = true
