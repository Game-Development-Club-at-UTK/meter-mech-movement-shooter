extends State
class_name DashingState


var start_pos: Vector3
var direction: Vector3
var timer: Timer
var should_exit = false


func _ready():
	has_gravity = false

# Uuuuuhhhh add coyote time maybe???
func proc(player: Player, delta):
	if (player.position - start_pos).length() >= player.dash_length:
		should_exit = true

	if should_exit:
		return player.IN_AIR_STATE
	
	player.velocity += direction * player.dash_speed * delta
	player.velocity.y = 0.0
	return


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

	if player.heat < player.dash_heat_cost:
		should_exit = true
	else:
		player.heat -= player.dash_heat_cost
	


# Create a timer as a backup to exit the dashing state in case the player gets stuck
func create_timer(player: Player):
	timer = Timer.new()
	timer.name = "DashTimer"
	timer.timeout.connect(_on_timeout)
	timer.one_shot = true
	timer.wait_time = 100 * player.dash_length / player.dash_speed
	add_child(timer)



func _on_timeout():
	should_exit = true
