extends KinematicBody2D

export (int) var speed = 120
export (int) var jump_speed = -180
export (int) var gravity = 400
export (int) var slide_speed = 400
export (int) var sprint=200
export (int) var rolling_time=0
export (int) var attack_time=0
export (int) var attack_sword_time=0
export (int) var rope_time=0
#export (int) var attack_sword_time=0
#var hit_s = Global.hit_side
var  ax = preload("res://Resources_Scenes/Player/sword/Ax.tscn")
var sword = preload("res://Resources_Scenes/Player/sword/sword.tscn")
var rope = load("res://Resources_Scenes/Rope/Rope.tscn")
var new_rope

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

var start_roll_timer = 0
var roll_timer

var adrenaline_resource = load("res://Resources_Scenes/HUD/Adrenaline.tscn")
var adrenaline

func _process(delta):
	restore_roll()
	animation_start_hit()
	if Global.plr_health <= 0:
		die()

func _ready():
	easter_egg_check()
	$AnimationPlayer.play("Idle")
	pass

func sprint():
	if Input.is_action_just_pressed("sprint") and velocity != Vector2.ZERO:
		speed=sprint
	elif Input.is_action_just_released("sprint")==true:
		speed=120
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
	match(player_state):
		state.STARTJUMP:
			velocity.y = jump_speed
			if jump_speed != -180:
				jump_speed = -180
			if get_node("Adrenaline").visible:
				get_node("Adrenaline").visible = false
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
		
func is_roping():
	var time_now_rope = OS.get_ticks_msec()
	if time_now_rope - rope_time > 1100:
		return false
	return true
	
func do_rope():
	if Input.is_action_pressed("rope"):
		if get_node_or_null("Rope") == null:
			rope_time = OS.get_ticks_msec()
			new_rope = rope.instance()
			self.add_child(new_rope)
			if Global.plr_flipped:
				new_rope.scale.x = -1
			get_node("Rope/AnimatedSprite").playing = true
			yield(get_tree().create_timer(2),"timeout")
			get_node("Rope").queue_free()

func do_rope_top():
	if Input.is_action_pressed("rope_top"):
		if get_node_or_null("Rope") == null:
			rope_time = OS.get_ticks_msec()
			new_rope = rope.instance()
			new_rope.scale.y = -1
			if Global.plr_flipped:
				new_rope.scale.x = -1
			self.add_child(new_rope)
			get_node("Rope/AnimatedSprite").playing = true
			yield(get_tree().create_timer(2),"timeout")
			get_node("Rope").queue_free()
		
func attack():
	if Input.is_action_just_pressed("attack"):
		attack_time = OS.get_ticks_msec()
		player_state=state.ATTACK


		
func swording():
	if throw_hand.get_node_or_null("sword")== null:
		if Input.is_action_just_pressed("sword_atk"):
			attack_time = OS.get_ticks_msec()
			player_state=state.ATTACK
			var new_sword = sword.instance()
			if throw_hand.position.x<0:
				new_sword.flip_sword()
			#print(new_sword.position)
			throw_hand.add_child(new_sword)
			
		
func shoot():
	if Input.is_action_just_pressed("shoot"):
		if Global.plr_trow > 0:
			Global.plr_trow -= 1
			var new_ax = ax.instance()
			new_ax.position = throw_hand.position
			self.add_child(new_ax)

func rolling():
	if is_on_floor() and Input.is_action_just_pressed("roll"):
		if Global.plr_rolls > 0:
			start_roll_timer = OS.get_ticks_msec()
			Global.plr_rolls -= 1
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

func restore_roll():
	if Global.plr_rolls < 3:
		roll_timer = OS.get_ticks_msec()
		if roll_timer - start_roll_timer > 3000:
			start_roll_timer = OS.get_ticks_msec()
			Global.plr_rolls += 1

func _physics_process(delta):
	if !Global.plr_get_hit:
		check_fall()
		move_with_platform()
		shoot()
		rolling()
		attack()
		get_input()
		sprint()
		swording()
		do_rope()
		do_rope_top()
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
	get_node("../").reset_level()
	Global.plr_health=3

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
	if area.is_in_group("platform"):
		p_area = area
	if area.is_in_group("fireball"):
		Global.plr_health-=1
		Global.plr_get_hit=true
		if Global.plr_health <= 0:
			die()
	if area.is_in_group("slime_hurtbox"):
		velocity.y = lerp(-2, -knockup * 2, 0.6)
	if area.is_in_group("terrain") and position.x > 600:
		if get_node("../").difficulty > 1:
			get_node("Adrenaline").visible = true
			jump_speed = -400
func _on_Hurtbox_area_exited(area):
	if area.is_in_group("platform"):
		p_area = null
	#if area.is_in_group("terrain"):


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
	if position.y >= 200:
		die()

func animation_start_hit():
	if Global.plr_get_hit:
		Global.plr_get_hit = false
		$AnimationPlayer.play("get_hit")
		yield(get_tree().create_timer(0.2),"timeout")
		
		
