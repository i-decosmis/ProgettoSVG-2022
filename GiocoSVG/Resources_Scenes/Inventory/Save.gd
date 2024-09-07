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


func _on_Save_pressed():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(save()))
	save_game.close()
	get_node("../../").visible = !visible
	
func save():
	var save_dict = {
		"lvl_defeated" : get_tree().get_root().get_node("Game").lvl_defeated
	}
	return save_dict
