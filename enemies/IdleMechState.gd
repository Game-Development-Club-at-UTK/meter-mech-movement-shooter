extends enemyState
@export var animPlayer : AnimationPlayer
@export var animTree : AnimationTree

var counter : float = 0
var delay : float = 0

func enter():
	data = owner.data
	while false :
		print("hahahaha")
	

func update(delta):
	#behavior: look around every few seconds
	counter += delta
	print(counter)
	if(counter >= delay):
		counter = 0
		delay = randf_range(3,5)  #3 to 5 seconds, I hope
		
		owner.desiredYaw = randf_range(-data.maxYaw, data.maxYaw)
		#owner.desiredPitch = randf_range(-data.maxPitch, data.maxPitch)
		owner.desiredPitch = 0
		owner.desiredRot = 0


	
	
	
	
	
	
	
	
	
