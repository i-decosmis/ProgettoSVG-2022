extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node("../../").difficulty == 1:
		get_node("CollisionPolygon2DTerrain/Polygon2DTerrain").texture = load("res://Resources_Scenes/PlatformTestV2/platformTerrainOne.png")
	elif get_node("../../").difficulty == 2:
		get_node("CollisionPolygon2DTerrain/Polygon2DTerrain").texture = load("res://Resources_Scenes/PlatformTestV2/platformTerrainTwo.png")
	elif get_node("../../").difficulty == 3:
		get_node("CollisionPolygon2DTerrain/Polygon2DTerrain").texture = load("res://Resources_Scenes/PlatformTestV2/platformTerrainThree.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
