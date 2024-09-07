extends Node2D

var lvl_defeated
var easterEgg
var easterEggChecked
var top_resource = load("res://Scenes/Menu/Menu.tscn")
var top
var do_top = false
var video_resource = load("res://Resources_Scenes/Cutscene/VideoPlayer.tscn")
var video
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	video = video_resource.instance()
	video.name = "video"
	self.add_child(video)

func _process(delta):
	if !Global.start_video and !do_top:
		get_node("video").queue_free()
		do_top = true
		lvl_defeated = 0
		easterEgg = false
		easterEggChecked = false
		load_game()
		top = top_resource.instance()
		top.name = "Top"
		self.add_child(top)
	if !Global.start_video:
		lvl_defeated = get_node("Top/Menu").lvl_defeated
		easterEgg = get_node("Top").easterEgg
		if Input.is_action_pressed("full_screen"):
			OS.window_fullscreen = !OS.window_fullscreen
	
func reset_top():
	self.remove_child(get_node("Top"))
	top = top_resource.instance()
	top.name = "Top"
	self.add_child(top)
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	save_game.open("user://savegame.save", File.READ)
	var node_data = parse_json(save_game.get_line())
	lvl_defeated = node_data["lvl_defeated"]
	save_game.close()


