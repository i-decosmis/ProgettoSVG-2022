extends Area2D


func flip_sword():
	$CollisionShape2D.scale=Vector2(-1,1)
	$Sprite.flip_h=true
	$Sprite.position.x-=13
	
func _ready():
	load_sprite_texture()
	remove()
	

func attack():
	$AnimationPlayer.play("swording")
	
func _physics_process(delta):
	#if Global.plr_flipped==false:
		#$Sprite.flip_h==false
		#print("girato")
		#attack()
	#if Global.plr_flipped==true:
		#$Sprite.flip_h==true
		#print("non")
		attack()



func _on_sword_body_entered(body):
	if body.is_in_group("enemy"):
		pass
		#body.die()
		#Global.boss_health-=1
		#body.animation_getHit()
		#position = body.global_position

	if body.is_in_group("slime"):
		#body.die()
		#Global.slime_health-=1
		body.animation_getHit()
		#position = body.global_position


func remove():
	yield(get_tree().create_timer(0.32), "timeout")
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

