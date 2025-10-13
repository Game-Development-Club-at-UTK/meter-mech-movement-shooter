extends State
@export var animPlayer : AnimationPlayer
func enter():
	print("Entering Idle State")

func update(_delta):
	# Optional: play idle animation or look around
	animPlayer.play("idle")
	pass
