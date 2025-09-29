extends Node3D

var selfVelocity = Vector3(0,0,0)
var lifetime = 120 #lifetime in frames

func _ready():
	self.position = $"..".global_position
	selfVelocity = $"..".currentLookDirection * 20
	self.look_at(selfVelocity)
	
	print(selfVelocity)

func _process(delta):
	lifetime -= 1
	if lifetime <= 0:
		self.queue_free()
	self.position += selfVelocity * delta
