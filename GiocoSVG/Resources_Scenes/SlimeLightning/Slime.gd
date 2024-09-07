extends KinematicBody2D

var speed = 55
var moving_left = true
var movement = Vector2()
const GRAVITY = 32
const UP = Vector2.UP
var is_dead = false
onready var l_ray = $l_ray
onready var animated_sprite = $AnimatedSprite
var start
var cooldown_knockup
var cooldown_knockup_start=null
var has_hit_animation=false
var slime_type
export (int) var hit_time=0
var slime_health = 2


func is_hitted():
	var time_now_hit = OS.get_ticks_msec()
	print("madonna ladra")
	if time_now_hit-hit_time>300:
		return false
	return true


func move():
	
	movement.y += GRAVITY
	
	movement.x = -speed if moving_left else speed

	movement = move_and_slide(movement, UP )

func _physics_process(delta):
	if is_dead==false:
		var collision=l_ray.is_colliding()
		if l_ray.is_colliding():
			moving_left = !moving_left
			scale.x = scale.x * -1
		move()
		sprite_walk()
			
	#sprite_walk()

func sprite_walk():

	if moving_left == true and is_dead==false and has_hit_animation==false:
		$AnimatedSprite.play("walking")

	elif moving_left == false and is_dead==false and has_hit_animation==false:
		$AnimatedSprite.play("walking")

	elif movement == Vector2.ZERO and is_dead==false and has_hit_animation==false:
		$AnimatedSprite.play("idle")

func _on_hitbox_l_area_entered(area):
	if area.is_in_group("player"):
		Global.hit_side = -1
		if cooldown():
			Global.plr_health-=1
			Global.plr_get_hit = true
			cooldown_knockup_start=OS.get_ticks_msec()

func _on_hitbox_r_area_entered(area):
	if area.is_in_group("player"):
		Global.hit_side = 1
		if cooldown():
			print("enter")
			Global.plr_health-= 1
			Global.plr_get_hit = true
			cooldown_knockup_start=OS.get_ticks_msec()

			
func cooldown():
	if cooldown_knockup_start==null:
		print("entro1")
		cooldown_knockup_start=OS.get_ticks_msec()
		return true
	cooldown_knockup = OS.get_ticks_msec()
	if cooldown_knockup-cooldown_knockup_start>150:
		cooldown_knockup_start=OS.get_ticks_msec()
		return true
	return false



func _on_hurtbox_area_entered(area):
	if area.is_in_group("ax"):
		has_hit_animation=true
		animation_getHit()
		if Global.type_used == "fire":
			slime_health -= 2
		else:
			slime_health-=1
	if area.is_in_group("player"):
		slime_health -= 2

func animation_getHit():
	if is_dead==false and slime_health>0 and has_hit_animation==true:
		speed=0
		$AnimatedSprite.play("get_hit")
		yield(get_tree().create_timer(0.3),"timeout")
		speed=55
		has_hit_animation=false

func die():
	if slime_health<=0 and !is_dead:
		$CollisionShape2D.disabled = true
		$hitbox_l/CollisionShape2D.disabled=true
		$hitbox_r/CollisionShape2D.disabled=true
		$hurtbox/CollisionShape2D.disabled=true
		is_dead = true
		speed=0
		animation_death()


func animation_death():
	is_dead=true
	speed=0
	print("entra")
	$AnimatedSprite.play("death")
	yield(get_tree().create_timer(1),"timeout")
	remove()
	
func _process(delta):
	if slime_health <= 0:
		die()

func remove():
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()

func _ready():
	#slime_type=get_node("../").slime_type
	$AnimatedSprite.play("idle")
