extends Node3D

var selfVelocity = Vector3(0,0,0)

func _ready():
	self.position = $"..".global_position
	selfVelocity = $"..".currentLookDirection * 20
	print(selfVelocity)

func _process(delta):
	self.position += selfVelocity * delta
