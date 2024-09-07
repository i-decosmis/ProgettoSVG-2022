extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("PortalTwo").playing = true



func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		area.get_node("CollisionShape2D").disabled = true
		get_node("../").end_level()
