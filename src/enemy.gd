extends CharacterBody3D
class_name Enemy


@export var max_health = 10.0
var health = max_health


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= 30.0 * delta
	
	move_and_slide()

func _process(delta):
	if health <= 0.0:
		print("I died! :(")
		health = max_health
