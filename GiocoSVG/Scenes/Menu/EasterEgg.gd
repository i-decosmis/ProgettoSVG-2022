extends Node2D

var camera = Camera2D.new()
var camera_offset = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		create_camera()
		
func create_camera():
	camera.position.x = 0
	camera.position.y = 0
	camera.current = true
	camera.set_name("camera")
	get_node("../Menu/Player").scale.x = 1
	get_node("../Menu/Player").scale.y = 1
	get_node("../Menu/Player").add_child(camera)

