extends CharacterBody3D

@export var target_position: Vector3
@export var speed: float = 4
@export var target_node : Node3D
@onready var idle_state = $IdleState
@onready var walk_state = $walkState
@onready var timer = $Timer

var current_state: State

func _ready():
	randomize()
	timer.timeout.connect(_on_timer_timeout)
	switch_state(idle_state)
	timer.start(2.0)

	$AnimationPlayer.play("goodWalk")  # Looping animation
	target_position =target_node.global_transform.origin
   # animation_player.current_animation_loop = true

func _physics_process(delta):
	if current_state:
		current_state.update(delta)
		
		
func switch_state(new_state: State):
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func _on_timer_timeout():
	if current_state == idle_state:
		switch_state(walk_state)
	timer.start(randf_range(1.5, 3.0))
