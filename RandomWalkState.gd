extends State
@export var animPlayer : AnimationPlayer
@export var move_speed := 1.9
var direction := Vector3.ZERO
var target_position = Vector3.ZERO
var target_rotation = Vector3.ZERO
var reachedTarget : bool

func enter():
	print("Entering Random Walk State")
	reachedTarget = false
	
	#choose random patrol point in a radius of 100 units
	#later, I should make the radius adjustable
	target_position = Vector3(
		owner.global_position.x + randf_range(-10, 10),
		0,
		owner.global_position.z + randf_range(-10, 10)
	)
	target_rotation = owner.transform.looking_at(target_position, Vector3.UP).basis.get_euler()

func update(delta):
	if(reachedTarget):
		owner.switch_state(owner.idle_state)
	#first, rotate to face the target
	#owner.transform.basis.get_euler()
	if(! owner.rotation.is_equal_approx(target_rotation)):
		
		#find whether we should rotate left or right for the smallest path
		if(target_rotation.y < 0):
			owner.rotation.y -= deg_to_rad(45) * delta #rotate 45 degrees per second
		else:
			owner.rotation.y += deg_to_rad(45) * delta #rotate 45 degrees per second
		#play a turning animation
		animPlayer.play("turn")
		print(owner.rotation)
		print(target_rotation)

		#if we're close enough to the target angle, just go ahead and set it there.
		if(abs(owner.rotation.y - target_rotation.y) < .2):
			owner.rotation.y = target_rotation.y
	#if angle is good, move to the target
	else:
		animPlayer.play("goodWalk")
		#find direction, distance, etc. and stop if we get close enough
		direction = (target_position - owner.global_transform.origin).normalized()
		var distance = owner.global_position.distance_to(target_position)
		if distance > 1:  # Stop when close enough
			owner.velocity = direction * move_speed
			owner.move_and_slide()
			
			
		else:
			owner.velocity = Vector3.ZERO
			reachedTarget = true
			print("reached position")
	
