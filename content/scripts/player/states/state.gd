@abstract
extends Node
class_name State


var has_gravity = true


func proc(player: Player, delta):
	if not player.is_on_floor() and has_gravity:
		player.velocity.y -= player.gravity * delta


func on_enter(_player: Player):
	pass


func on_exit(_player: Player):
	pass
