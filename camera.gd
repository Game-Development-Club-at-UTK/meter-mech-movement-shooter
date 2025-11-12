extends Camera3D

# The "actual" rotation of the camera before application of effects like camera shake
# when accessing the camera's rotation use this variable instead of the class's default one to avoid including the influence of effects
var true_rotation = rotation

func _process(delta):
	rotation = true_rotation
