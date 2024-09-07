extends Area2D


func flip_sword():
	$CollisionShape2D.scale=Vector2(-1,1)
	$Sprite.flip_h=true
	$Sprite.position.x-=13
	
func _ready():
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
		#body.die()
		Global.boss_health-=1
		body.animation_getHit()
		position = body.global_position
		print("COLPITO AONNA")
		if Global.boss_health<=0:
			body.animation_death()
			remove()
		#movable = false

func remove():
	yield(get_tree().create_timer(0.32), "timeout")
	queue_free()


