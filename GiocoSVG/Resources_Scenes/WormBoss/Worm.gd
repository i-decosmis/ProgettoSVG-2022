extends KinematicBody2D
var speed = 75
var moving_left = true
var movement = Vector2()
const GRAVITY = 32
const UP = Vector2.UP
var is_dead = false
onready var l_ray = $l_ray
onready var animated_sprite = $AnimatedSprite
var has_hit= false
var has_hit_animation = false
var fireball = preload("res://Resources_Scenes/WormBoss/Boss_atk/FireBall.tscn")
var state_attacking = false
var is_active = false
onready var throw_fireball = $Position2D
var time_atk_now_boss=0
var start
var cooldown_knockup
var cooldown_knockup_start
var sound_wake_up = AudioStreamPlayer2D.new()
var sound_wake_up_path = "res://Resources_Scenes/Audio/bossWakeUp.wav"
var portal_path = load("res://Resources_Scenes/Portals/PortalThree/Portal.tscn")
var portal
var portal_created = false

func _ready():
	sound_wake_up.stream = load(sound_wake_up_path)
	sound_wake_up.set_volume_db(20)
	self.add_child(sound_wake_up)
	$AnimatedSprite.play("Idle")

func _physics_process(delta):
	if is_active == true:
		#print(Global.plr_health)
		if state_attacking==false:
			if !is_dead:
				if is_attacking():
					#print("aaaaattaccando")
					attack()
					start= OS.get_ticks_msec()
				var collision=l_ray.is_colliding()
				if l_ray.is_colliding():
					moving_left = !moving_left
					#l_ray.scale.x = -l_ray.scale.x
					#animated_sprite.scale.x = -animated_sprite.scale.x
					$Position2D.scale.x = $Position2D.scale.x * -1
					$CollisionShape2D.scale.x = $CollisionShape2D.scale.x * -1
					$AnimatedSprite.scale.x = $AnimatedSprite.scale.x * -1
					$l_ray.scale.x = $l_ray.scale.x * -1
					$hitbox_l.scale.x = $hitbox_l.scale.x * -1
					$hitbox_r.scale.x = $hitbox_r.scale.x * -1
					$hurtbox.scale.x = $hurtbox.scale.x * -1
					
				move()
				sprite_walk()
			else:
				speed=0
	else:
		movement.y += GRAVITY
		movement = move_and_slide(movement, UP )
		
func _process(delta):
	if Global.boss_health <= 0:
		die()
		if !portal_created and is_dead:
			create_portal()

func attack():
	if is_active==true:
		state_attacking=true
		speed=0
		#print("entra")
		$AnimatedSprite.play("Attack")
		yield(get_tree().create_timer(3.1),"timeout")
		shoot()
		state_attacking=false
		speed=75
		
func is_attacking():
	time_atk_now_boss = OS.get_ticks_msec()
	if time_atk_now_boss-start>10000:
		start=OS.get_ticks_msec()
		return true
	return false


func shoot():
	var new_fireball = fireball.instance()
	new_fireball.position = throw_fireball.position
	self.add_child(new_fireball)

func move():
	
	movement.y += GRAVITY
	
	movement.x = -speed if moving_left else speed

	movement = move_and_slide(movement, UP )
	
	if moving_left==true:
		Global.worm_boss_flipped=false
	else:
		Global.worm_boss_flipped=true
		
func sprite_walk():
	if is_active == true:
		if state_attacking==false:
			if moving_left == true and is_dead==false:
				if throw_fireball.position.x>0:
					throw_fireball.position.x= throw_fireball.position.x * -1
				$AnimatedSprite.play("Walk")
			elif moving_left == false and is_dead==false:
				if throw_fireball.position.x<0:
					throw_fireball.position.x= throw_fireball.position.x * -1
				$AnimatedSprite.play("Walk")
			elif movement == Vector2.ZERO and is_dead==false:
				$AnimatedSprite.play("Idle")



#func _on_hitbox_l_body_entered(body):
#	if body is KinematicBody:
#		queue_free()
#	pass # Replace with function body.
func cooldown():
	if cooldown_knockup_start==null:
		cooldown_knockup_start=OS.get_ticks_msec()
		return true
	cooldown_knockup = OS.get_ticks_msec()
	if cooldown_knockup-cooldown_knockup_start>150:
		cooldown_knockup_start=OS.get_ticks_msec()
		return true
	return false


func _on_hitbox_l_area_entered(area):
	if area.is_in_group("player"):
		Global.hit_side = -1
		if is_active == true:
			if cooldown():
				Global.plr_health-=1
				Global.plr_get_hit=true
				cooldown_knockup_start=OS.get_ticks_msec()


func _on_hitbox_r_area_entered(area):
	if area.is_in_group("player"):
		Global.hit_side = 1
		if is_active == true:
			if cooldown():
				Global.plr_health-= 1
				Global.plr_get_hit=true
				cooldown_knockup_start=OS.get_ticks_msec()

func animation_death():
	is_dead=true
	speed=0
	$AnimatedSprite.play("Death")
	yield(get_tree().create_timer(0.8),"timeout")
	remove()


func animation_getHit():
	if is_active == true:
		if !state_attacking:
			if is_dead==false and Global.boss_health>0 and has_hit_animation==true:
				speed=0
				$AnimatedSprite.play("getHit")
				yield(get_tree().create_timer(0.3),"timeout")
				speed=75
				has_hit_animation=false


#func _on_hurtbox_body_entered(body):
	#if body is KinematicBody2D:
	#	has_hit_animation=true
	#	animation_getHit()
	#	Global.boss_health-=1
		#if Global.boss_health<=0:
		#	is_dead = true
		#	animated_sprite.play("Death")
			#$hitbox_l/CollisionShape2D.disabled=true
		#	$hitbox_r/CollisionShape2D.disabled=true
			#$hurtbox/CollisionShape2D.disabled=true
			#remove()

func animation_attack():
	$AnimatedSprite.play("Attack")
	
func die():
	if Global.boss_health<=0 and !is_dead:
		is_dead = true
		speed=0
		animated_sprite.play("Death")
		$hitbox_l/CollisionShape2D.disabled=true
		$hitbox_r/CollisionShape2D.disabled=true
		$hurtbox/CollisionShape2D.disabled=true
		$Boss_wakeup/CollisionShape2D.disabled=true
		set_collision_layer(64)
		set_collision_mask(64)
		#$CollisionShape2D.disabled = true
		#remove()
		
func remove():
	yield(get_tree().create_timer(1.55), "timeout")
	queue_free()

func _on_hurtbox_area_entered(area):
	if is_active == true:
		if area.is_in_group("ax"):
			has_hit_animation=true
			animation_getHit()
			if Global.type_used == "normal":
				Global.boss_health-=1
			elif Global.type_used == "water":
				Global.boss_health-=2


func _on_Boss_wakeup_body_entered(body):
	if body.is_in_group("player"):
		if is_active==false:
			get_node("../../../").song.stop()
			sound_wake_up.play()
			yield(sound_wake_up, "finished") 
			get_node("../../../").song_boss.play()
			is_active = true
			start=OS.get_ticks_msec()

func create_portal():
	portal_created = true
	yield(get_tree().create_timer(1.6), "timeout")
	portal = portal_path.instance()
	portal.position.x = position.x
	portal.position.y = position.y - 30
	get_node("../").add_child(portal)
