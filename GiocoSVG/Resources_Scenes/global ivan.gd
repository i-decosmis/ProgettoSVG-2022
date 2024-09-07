extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_xy_large_p():
	var coords = Vector2(42,6)
	return coords
	
func get_xy_medium_p():
	var coords = Vector2(16,4)
	return coords
	
func get_xy_small_p():
	var coords = Vector2(8,4)
	return coords
	
