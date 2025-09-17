extends State
class_name DashingState


var start_pos: Vector3
var direction: Vector3

# Uuuuuhhhh add coyote time maybe???
func proc(player: Player, delta):
	if (player.position - start_pos).length() >= player.dash_length or direction.length() == 0.0:
		return player.IN_AIR_STATE
	
	player.velocity += direction * player.dash_speed * delta
	player.velocity.y = 0.0


func on_enter(player: Player):
	start_pos = player.position
	direction = Vector3()

	if Input.is_action_pressed("forward"):
		direction += Vector3.FORWARD
	if Input.is_action_pressed("back"):
		direction += Vector3.BACK
	if Input.is_action_pressed("left"):
		direction += Vector3.LEFT
	if Input.is_action_pressed("right"):
		direction += Vector3.RIGHT
	
	direction = direction.normalized()
	direction = direction.rotated(Vector3(0.0, 1.0, 0.0), player.rotation.y)
	print(direction)
