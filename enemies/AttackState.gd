extends enemyState
@export var animPlayer : AnimationPlayer
@export var animTree : AnimationTree
var x : float
var targetRotation
func enter():
	data = owner.data
	x = owner.leftArmPos.global_transform.origin.distance_to(owner.rightArmPos.global_transform.origin)
	while false :
		print("hahahaha")
	

func update(delta):


	var targetWorldLoc = owner.lookTargetNode.global_position
	#targetRotation = owner.eyePosition.global_transform.looking_at(targetWorldLoc, Vector3.UP).basis.get_euler()
	var targetTransform = owner.eyePosition.global_transform.looking_at(targetWorldLoc, Vector3.UP)
	var ownerTransform = owner.global_transform
	var finalTransform = (ownerTransform.affine_inverse() * targetTransform)
	targetRotation = finalTransform.basis.get_euler()

	
	
	owner.desiredYaw = rad_to_deg(targetRotation.y)
	owner.desiredPitch = rad_to_deg(targetRotation.x)
	
	if(owner.desiredYaw < -data.maxYaw):
		owner.global_rotation.y -= deg_to_rad(data.turn_rate) * delta #rotate 45 degrees per second

	if(owner.desiredYaw > data.maxYaw):
		owner.global_rotation.y += deg_to_rad(data.turn_rate) * delta #rotate 45 degrees per second
	
	#rotate arms theta = tan-1(2y/x)
	#x = local distance between arm bones (set in enter to save time)
	#y = distance between torso and player
	var y = owner.eyePosition.global_transform.origin.distance_to(owner.lookTargetNode.global_position)	
	var theta = atan((2 * y) / x)
	owner.desiredRot = 90 - abs(rad_to_deg(theta))
	
	
	
	
	
	
	
	
	
