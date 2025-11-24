extends Camera3D

@export_group("Camera Shake")
@export var trauma_decay = 0.5
@export var max_yaw = PI / 6
@export var max_pitch = PI / 6
@export var max_roll = PI / 6

# The "actual" rotation of the camera before application of effects like camera shake
# when accessing the camera's rotation use this variable instead of the class's default one to avoid including the influence of effects
# At current moment, some objects like viewmodels or lookPosition are also influenced due to being parented directly to Camera3D.
# Maybe consider reparenting them to a single, common parent that is rotated instead of the camera?
var true_rotation = rotation

# Float ranging over [0.0, 1.0] that influences camera shake and decays over time
# More trauma = more shake
var trauma = 0.0

# Perlin noise used for camera shake
var noise_y: FastNoiseLite
var noise_p: FastNoiseLite
var noise_r: FastNoiseLite


func _ready():
	$"..".camera = self
	noise_r = FastNoiseLite.new()
	noise_r.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_y = noise_r.duplicate_deep()
	noise_p = noise_r.duplicate_deep()
	noise_r.seed = randi()
	noise_y.seed = randi()
	noise_p.seed = randi()


func _process(delta):
	trauma = clampf(trauma, 0.0, 1.0)
	rotation = true_rotation

	var shake = trauma * trauma
	var frame = Engine.get_frames_drawn()
	rotation.y += max_yaw * shake * noise_y.get_noise_1d(frame)
	rotation.x += max_pitch * shake * noise_p.get_noise_1d(frame)
	rotation.z += max_roll * shake * noise_r.get_noise_1d(frame)
	
	trauma -= trauma_decay * delta
