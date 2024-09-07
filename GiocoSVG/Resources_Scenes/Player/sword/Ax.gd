extends Area2D

var movable = true
var speed
var rot_speed = 15

func _physics_process(delta):
	if movable == true:
		position.x += speed * delta
		global_position.y += 0.80
	rotate(deg2rad(15))
	
func _ready():
	load_sprite_texture()
	if Global.plr_flipped == false:
		speed = 300
	elif Global.plr_flipped == true:
		speed= -300
	rot_speed = 15

func _on_Ax_body_entered(body):
	if body.is_in_group("enemy"):
		#Global.boss_health-=1
		speed = 0
		#position = body.global_position
		rot_speed=0
		movable = false
		remove()
	if body.is_in_group("slime"):
		#Global.boss_health-=1
		speed = 0
		#position = body.global_position
		rot_speed=0
		movable = false
		remove()


func remove():
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()
	
func load_sprite_texture():
	if Global.type_used == "water":
		get_node("Sprite").texture = load("res://Sprites/sword_effect_strip_4_water.png")
	elif Global.type_used == "fire":
		get_node("Sprite").texture = load("res://Sprites/sword_effect_strip_4_fire.png")
	elif Global.type_used == "lightning":
		get_node("Sprite").texture = load("res://Sprites/sword_effect_strip_4_lighting.png")
	else:
		get_node("Sprite").texture = load("res://Sprites/sword_effect_strip_4(new).png")
