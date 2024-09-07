extends StaticBody2D

var type = "medium"
var enemy = "free"
var offset = [-30,30]
var pos = 0
var is_moving = "left"
var rng = RandomNumberGenerator.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
		if get_node("../../").difficulty == 2:
			get_node("CollisionPolygon2D/Polygon2D").texture = load("res://Resources_Scenes/FlyingPlatformMediumBoss/floating_platform_two.png")
		elif get_node("../../").difficulty == 3:
			get_node("CollisionPolygon2D/Polygon2D").texture = load("res://Resources_Scenes/FlyingPlatformMediumBoss/floating_platform_three.png")
		rng.randomize()
		var chance = rng.randi_range(1,2)
		if chance == 1:
			is_moving = "right"
		else:
			is_moving = "left"

func _physics_process(delta):
	move()
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

func move():
	if is_moving == "left" and pos > -30:
		move_left()
	elif is_moving == "left" and pos == -30:
		move_right()
		is_moving = "right"
	elif is_moving == "right" and pos < 30:
		move_right()
	elif is_moving == "right" and pos == 30:
		move_left()
		is_moving = "left"
func move_left():
	position.x -= 0.5
	pos-=0.5
func move_right():
	position.x += 0.5
	pos+=0.5


func _on_Area2D_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("item"):
		body.is_colliding_moving_p = true


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		body.is_colliding_moving_p = false
