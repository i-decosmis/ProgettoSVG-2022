extends KinematicBody2D

export (int) var speed = 120
export (int) var jump_speed = -180
export (int) var gravity = 400
export (int) var slide_speed = 400
export (int) var sprint=200
export (int) var rolling_time=0
export (int) var attack_time=0
export (int) var attack_sword_time=0
#export (int) var attack_sword_time=0
#var hit_s = Global.hit_side
var  ax = preload("res://Resources_Scenes/Player/sword/Ax.tscn")
var sword = preload("res://Resources_Scenes/Player/sword/sword.tscn")
onready var throw_hand = $Position2D
export var knockback = 700
export var knockup = 100

var velocity = Vector2.ZERO

export (float) var friction=10
export (float) var acceleration=25

enum state {IDLE,RUNNING,PUSHING,ROLLING,JUMP,STARTJUMP,FALL,ATTACK}

onready var player_state = state.IDLE

var is_colliding_moving_p = false
var p_area = null

func _ready():
	easter_egg_check()
	$AnimationPlayer.play("Idle")

func sprint():
	if Input.is_action_just_pressed("sprint") and velocity != Vector2.ZERO:
		#print("veloce")
		speed=sprint
	elif Input.is_action_just_released("sprint")==true:
		speed=120
		#print("normale")
	pass


func update_animation(anim):
	#$AnimationPlayer.play(anim)
	if velocity.x < 0:
		$Sprite.flip_h = true
		Global.plr_flipped=true
		if throw_hand.position.x>0:
			throw_hand.position.x= throw_hand.position.x * -1
	elif velocity.x > 0:
		$Sprite.flip_h = false
		Global.plr_flipped=false 
		if throw_hand.position.x < 0:
			throw_hand.position.x= throw_hand.position.x * -1
	match(anim):
		state.FALL:
			$AnimationPlayer.play("fall")
		state.ATTACK:
			$AnimationPlayer.play("attack")
		state.IDLE:
			$AnimationPlayer.play("Idle")
		state.JUMP:
			$AnimationPlayer.play("jump")
		state.PUSHING:
			$AnimationPlayer.play("pushing")
		state.RUNNING:
			$AnimationPlayer.play("Running")
		state.ROLLING:
			$AnimationPlayer.play("roll")
	pass
	
func handle_state(player_state):
	#print(state)
	match(player_state):
		state.STARTJUMP:
			velocity.y = jump_speed
	pass

func get_input():
	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	if direction !=0:
		velocity.x= move_toward(velocity.x, direction*speed, acceleration)
	else:
		velocity.x= move_toward(velocity.x, 0, friction)

func is_rolling():
	var time_now = OS.get_ticks_msec()
	if time_now-rolling_time>300:
		return false
	return true
	
func is_attacking():
	var time_now_atk = OS.get_ticks_msec()
	if time_now_atk-attack_time>300:
		return false
	return true

func is_swording():
		var time_now_swording_atk = OS.get_ticks_msec()
		if time_now_swording_atk-attack_sword_time>300:
			return false
		return true
		
func attack():
	if Input.is_action_just_pressed("attack"):
		if get_node("../").lvl_defeated == 3:
			get_node("../Destra/CollisionShape2D").disabled = true
		#print("attack func")
		attack_time = OS.get_ticks_msec()
		player_state=state.ATTACK


		
func swording():
		if Input.is_action_just_pressed("sword_atk"):
			attack_time = OS.get_ticks_msec()
			player_state=state.ATTACK
			#print(throw_hand.position)
			var new_sword = sword.instance()
			#new_sword.position = throw_hand.position
			if throw_hand.position.x<0:
				new_sword.flip_sword()
				#new_sword.get_node("Sprite").flip_h=true
			print(new_sword.position)
			throw_hand.add_child(new_sword)
			
		
func shoot():
	if Input.is_action_just_pressed("shoot"):
		var new_ax = ax.instance()
		new_ax.position = throw_hand.position
		self.add_child(new_ax)

func rolling():
	if is_on_floor() and Input.is_action_just_pressed("roll"):
		#print(state.ROLLING)
		rolling_time= OS.get_ticks_msec()
		player_state=state.ROLLING
		match(player_state):
			state.ROLLING:
				if velocity.x>0:
					velocity.x=200
				elif velocity.x<0:
					velocity.x=-200
				elif velocity.x==0:
					if $Sprite.flip_h == true:
						velocity.x=-300
					elif $Sprite.flip_h == false:
						velocity.x=300
	pass

func _process(delta):
	easter_egg_check()
func _physics_process(delta):
	check_fall()
	move_with_platform()
	shoot()
	rolling()
	attack()
	get_input()
	sprint()
	swording()
	#print(is_on_floor())
	if velocity == Vector2.ZERO:
		player_state = state.IDLE
	if Input.is_action_just_pressed("jump") and is_on_floor():
		player_state = state.STARTJUMP
	elif velocity.x != 0:
		if is_rolling():
			player_state=state.ROLLING
		else: 
			player_state = state.RUNNING
		
	if is_attacking():
		#print("attacco")
		player_state=state.ATTACK
	if is_swording():
		player_state=state.ATTACK
	if  not is_on_floor():
		if velocity.y < 0:
			player_state = state.JUMP
		if velocity.y > 0:
			player_state= state.FALL
	
	handle_state(player_state)
	update_animation(player_state)
	#imposto gravità
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func die():
	position.x = 75
	position.y = 128
	scale.x =5
	scale.y = 5
	remove_child(get_node("camera"))

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("hitbox"):
		if area.is_in_group("hitbox_l"):
			Global.hit_side = -1
		elif area.is_in_group("hitbox_r"):
			Global.hit_side = 1
		var knock_side = knockback * Global.hit_side
		velocity.x = lerp(velocity.x, knock_side, 0.5)
		velocity.y = lerp(0, -knockup, 0.6)
		velocity = move_and_slide(velocity, Vector2.UP)
		#animazione danno qui
		if Global.plr_health <= 0:
			die()
	if area.is_in_group("platform"):
		p_area = area
	if area.is_in_group("fireball"):
		Global.plr_health-=1
		if Global.plr_health <= 0:
			die()
func _on_Hurtbox_area_exited(area):
	if area.is_in_group("platform"):
		p_area = null

func move_with_platform():
	if is_colliding_moving_p == true:
		if p_area != null:
			if p_area.get_node("../").is_moving == "left":
				self.position.x -= 1
			else:
				self.position.x += 1
				
func easter_egg_check():
	if get_tree().get_root().get_node("Game").easterEgg:
		get_node("Sprite").texture = load("res://Sprites/herochar_spritesheet(new)_gold.png")
		
func check_fall():
	if position.y >= 1200:
		die()
