extends State
class_name InAirState


func proc(player: Player, delta):
	if player.is_on_floor_only():
		return player.GROUNDED_STATE

	return super(player, delta)
