extends VideoPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#Global.start_video = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VideoPlayer_finished():
	get_tree().get_root().get_node("Game").lvl_defeated = 3
	get_node("../").end_top_lvl()
	
	


func _on_TextureButton_pressed():
	get_tree().get_root().get_node("Game").lvl_defeated = 3
	get_node("../").end_top_lvl()
	
