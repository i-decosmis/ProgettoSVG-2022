extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_Medium_pressed():
	start_lvl_medium()
	
func start_lvl_medium():
	get_node("../../").song.stop()
	get_node("../../").load_menu = false
	var one_resource = load("res://Scenes/WorldMedium/WorldMedium.tscn")
	var one = one_resource.instance()
	one.set_name("world")
	get_node("../../../").add_child(one)
	get_node("../../").hide()
	get_node("../../../TextureRect").hide()
	get_node("../../Player").queue_free()
	get_node("../../Base").queue_free()
	get_node("../../Sinistra").queue_free()
	get_node("../../Destra").queue_free()
	get_node("../../../EasterEgg").queue_free()
