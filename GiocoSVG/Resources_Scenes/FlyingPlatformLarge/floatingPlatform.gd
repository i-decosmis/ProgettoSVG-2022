extends StaticBody2D

var type = "large"
var enemy = "free"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node("../../").difficulty == 1:
		get_node("CollisionPolygon2D/Polygon2D").texture = load("res://Resources_Scenes/FlyingPlatformLarge/floating_platform_large_one.png")
	elif get_node("../../").difficulty == 2:
		get_node("CollisionPolygon2D/Polygon2D").texture = load("res://Resources_Scenes/FlyingPlatformLarge/floating_platform_large_two.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if area.get_node("../").has_method("get_platform_type"):
		print(area.get_node("../").name)
		print(self.name)
		print("posizione",area.get_node("../").position.y)
		self.position.y = self.position.y + 25
		self.position.x = self.position.x + 25
		print(area.get_node("../").position.y)
		area.free()
		
func get_platform_type():
	return type


