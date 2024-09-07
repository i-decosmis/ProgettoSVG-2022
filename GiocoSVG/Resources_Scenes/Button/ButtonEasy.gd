extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "_button_pressed")
	pass # Replace with function body.

func _button_pressed():
	#var one_resource = load("res://Scenes/WorldOne/WorldOne.tscn")
	var one_resource = load("res://Scenes/WorldOne/WorldOne.tscn")
	var one = one_resource.instance()
	one.set_name("mondo")
	get_node("../").add_child(one)
	get_node("../Menu").hide()
	get_node("../TextureRect").hide()
	get_node("../Menu/Player").queue_free()
	get_node("../Menu/StaticBody2D").queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
