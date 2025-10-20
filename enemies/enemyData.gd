extends Resource
#in theory, we'll eventually use this class to define all variables of an enemy, 
#and just import them to a single master scene.
class_name enemyData

@export var move_speed : float
@export var turn_rate : float #deg/s
