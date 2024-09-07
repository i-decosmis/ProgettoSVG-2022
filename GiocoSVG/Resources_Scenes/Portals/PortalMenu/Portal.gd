extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("PortalOne").playing = true



func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		return_to_menu(area)
		
func return_to_menu(var area):
	if get_tree().get_root().get_node("Game").lvl_defeated == 3:
		if get_tree().get_root().get_node("Game").easterEgg:
			get_tree().get_root().get_node("Game").easterEgg = false
		else:
			get_tree().get_root().get_node("Game").easterEgg = true
		get_tree().get_root().get_node("Game").reset_top()

