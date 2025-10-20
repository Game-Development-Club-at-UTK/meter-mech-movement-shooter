extends State
@export var animPlayer : AnimationPlayer
@export var animTree : AnimationTree
var targetRotation
func enter():
	print("Entering Idle State")
	
	
	

func update(_delta):
	var targetWorldLoc = owner.lookTargetNode.position
	targetRotation = owner.transform.looking_at(targetWorldLoc, Vector3.UP).basis.get_euler()
	
	#var direction = (targetWorldLoc - self.global_transform.origin).normalized()
	#var basis = Basis().looking_at(direction, Vector3.UP)
	#owner.yaw = basis.get_rotation_quaternion().y
	owner.yaw = rad_to_deg(owner.rotation.y + targetRotation.y)
	owner.pitch = rad_to_deg(owner.rotation.z - targetRotation.z)
	print(owner.yaw)
	
	
	
	
	
