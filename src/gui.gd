extends CanvasLayer
class_name GUI


var heat = 0.0


func _process(_delta):
	$Heat.text = String.num(heat)
	$HeatBar/HeatProgress.scale.x = heat
