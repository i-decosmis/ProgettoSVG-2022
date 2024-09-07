extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("PortalOne").playing = true



func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		return_to_menu(area)
		
func return_to_menu(var area):
	area.get_node("CollisionShape2D").disabled = true
	get_node("../../../").end_level()
	remove_loading_screen()
	
func remove_loading_screen():
	if get_node_or_null("../../loading") != null:
		get_node("../../").remove_child(get_node("loading"))
		get_node("../../loading").queue_free()
