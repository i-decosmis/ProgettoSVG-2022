extends Node2D

var lvl_defeated = 2
var load_menu = true
var song = AudioStreamPlayer2D.new()
var rng = RandomNumberGenerator.new()
var window_dim = Vector2(426,240)
var load_background = true
var camera = Camera2D.new()
var camera_offset = 5

var texture_lv_one = [load("res://Resources_Scenes/Backgrounds/Menu/LvOne/one.png"),
	load("res://Resources_Scenes/Backgrounds/Menu/LvOne/two.png"), load("res://Resources_Scenes/Backgrounds/Menu/LvOne/three.png"),
	load("res://Resources_Scenes/Backgrounds/Menu/LvOne/four.png")]
	
var texture_lv_two = [load("res://Resources_Scenes/Backgrounds/Menu/LvTwo/one.png"),
	load("res://Resources_Scenes/Backgrounds/Menu/LvTwo/two.png"), load("res://Resources_Scenes/Backgrounds/Menu/LvTwo/three.png"),
	load("res://Resources_Scenes/Backgrounds/Menu/LvTwo/four.png")]
	
var texture_lv_three = [load("res://Resources_Scenes/Backgrounds/Menu/LvThree/one.png"),
	load("res://Resources_Scenes/Backgrounds/Menu/LvThree/two.png"), load("res://Resources_Scenes/Backgrounds/Menu/LvThree/three.png"),
	load("res://Resources_Scenes/Backgrounds/Menu/LvThree/four.png"), load("res://Resources_Scenes/Backgrounds/Menu/LvThree/five.png")]


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	get_node("../TextureRect").texture = texture_lv_one[rng.randi_range(0,texture_lv_one.size()-1)]
	get_node("../TextureRect").expand = true
	get_node("../TextureRect").rect_min_size = window_dim
	song.stream = load("res://Resources_Scenes/Audio/menu.wav")
	get_node("GridContainer/Button Easy").add_child(song)
	get_node("GridContainer/Button Medium").hide()
	get_node("GridContainer/Button Hard").hide()
	get_node("GridContainer/Button Easy/Sprite1").show()
	lvl_defeated = get_node("../../").lvl_defeated
	song.play()

func _physics_process(delta):
	exit_from_controller()
	start_level()
	if load_menu:
		if lvl_defeated == 1:
			get_node("GridContainer/Button Medium").show()
			get_node("GridContainer/Button Easy/Sprite1").hide()
			get_node("GridContainer/Button Medium/Sprite2").show()
		elif lvl_defeated == 2:
			if load_background:
				load_background_f(texture_lv_two)
				load_background = false
			get_node("GridContainer/Button Medium").show()
			get_node("GridContainer/Button Hard").show()
			get_node("GridContainer/Button Medium/Sprite2").hide()
			get_node("GridContainer/Button Easy/Sprite1").hide()
			get_node("GridContainer/Button Hard/Sprite3").show()
			
		elif lvl_defeated == 3:
			if load_background:
				load_background_f(texture_lv_three)
				load_background = false
			get_node("GridContainer/Button Medium").show()
			get_node("GridContainer/Button Hard").show()
			get_node("GridContainer/Button Easy/Sprite1").hide()
			get_node("GridContainer/Button Medium/Sprite2").hide()
			get_node("GridContainer/Button Hard/Sprite3").show()
			
func load_background_f(var texture):
	get_node("../TextureRect").texture = texture[rng.randi_range(0,texture.size()-1)]
	get_node("../TextureRect").expand = true
	get_node("../TextureRect").rect_min_size = window_dim
	
func start_level():
	if Input.is_action_just_pressed("start_lvl") and load_menu:
		if lvl_defeated == 0:
			get_node("GridContainer/Button Easy").start_lv_easy()
		elif lvl_defeated == 1:
			get_node("GridContainer/Button Medium").start_lvl_medium()
		elif lvl_defeated == 2 or lvl_defeated == 3:
			get_node("GridContainer/Button Hard").start_lvl_hard()

func exit_from_controller():
	if Input.is_action_just_pressed("exit") and load_menu:
		exit_game()

func _on_Button_Exit_pressed():
	exit_game()
	
func exit_game():
	get_tree().quit()
