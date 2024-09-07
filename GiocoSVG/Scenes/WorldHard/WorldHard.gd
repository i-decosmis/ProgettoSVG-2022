extends Node2D


var chunk_path = "res://Resources_Scenes/ChunkHard/ChunkHard.tscn"
var chunk_resource = load(chunk_path)
var chunk = []
var chunk_number = 1
var chunk_to_load = 10
var path_player = "res://Resources_Scenes/Player/Player.tscn"
var player_resource = load(path_player)
var player_node
var player_position = Vector2(1,1)
var inventory_resource = load("res://Resources_Scenes/Inventory/Inventory.tscn")
var inventory
var camera = Camera2D.new()
var camera_offset = -40
var song = AudioStreamPlayer2D.new()
var song_boss = AudioStreamPlayer2D.new()
var tree_resource = load("res://Resources_Scenes/StartingPoint/TreeLvThree/TreeLvThree.tscn")
var tree_position = Vector2(1,1)
var tree_node
var difficulty = 3
var spawn_enemy = 3
var spawn_boss = false
var rng = RandomNumberGenerator.new()
var hud_resource = load("res://Resources_Scenes/HUD/HUD.tscn")
var hud
var loading_resource = load("res://Resources_Scenes/Loading Text/LoadingText.tscn")
var loading
var final_video_resource = load("res://Resources_Scenes/Cutscene_Final/VideoPlayer.tscn")
var final_video

# Called when the node enters the scene tree for the first time.
func _ready():
	create_chunk()
	create_player()
	create_camera()
	create_song()
	create_hud()
	remove_loading_screen()
	create_tree()

func create_chunk():
	for n in chunk_to_load:
		if n > 1:
			rng.randomize()
			spawn_enemy = rng.randi_range(4,6)
		if n == chunk_to_load - 1:
			print("entro")
			spawn_boss = true
		chunk.append(chunk_resource.instance())
		chunk[-1].set_name(str(n+1))
		self.add_child(chunk[-1])
		chunk_number += 1	
	
func create_player():
	player_node = player_resource.instance()
	if get_node("1/11") == null:
		player_position = get_node("1/1-1").get_position()
	else:
		player_position = get_node("1/11").get_position()
	player_position.y -= 15
	player_node.set_position(player_position)
	player_node.set_name("player")
	self.add_child(player_node)
	inventory = inventory_resource.instance()
	get_node("player").add_child(inventory)
	
func create_camera():
	camera.position.y += camera_offset
	camera.limit_top = -300
	camera.limit_bottom = 53
	camera.current = true
	camera.name = "camera"
	get_node("player").add_child(camera)

func create_song():
	song_boss.stream = load("res://Resources_Scenes/Audio/bossFight.wav")
	song.stream = load("res://Resources_Scenes/Audio/boss.wav")
	song.autoplay = true
	get_node("player").add_child(song)
	get_node("player").add_child(song_boss)

func create_tree():
	tree_node = tree_resource.instance()
	tree_node.position = get_node("1/10").get_position()
	tree_node.position.y -= 3
	tree_node.position.x -= 20
	tree_node.scale = tree_node.scale * 8
	self.add_child(tree_node)
	
func create_hud():
	hud = hud_resource.instance()
	hud.scale.x = 0.5
	hud.scale.y = 0.5
	hud.position.x = -190
	hud.position.y = -110
	get_node("player/camera").add_child(hud)
	
func end_level():
	song_boss.stop()
	#create_loading_screen()
	yield(get_tree().create_timer(0.1),"timeout")
	get_tree().get_root().get_node("Game").lvl_defeated = 3
	print(get_tree().get_root().get_node("Game").lvl_defeated)
	song.stop()
	final_video = final_video_resource.instance()
	final_video.name = "final"
	get_node("player").queue_free()
	self.add_child(final_video)
	print(get_tree().get_root().get_node("Game").lvl_defeated)
	
func end_top_lvl():
	print(get_tree().get_root().get_node("Game").lvl_defeated)
	get_tree().get_root().get_node("Game").reset_top()
	print("test")
	self.queue_free()
	
func reset_level():
	song_boss.stop()
	yield(get_tree().create_timer(0.1),"timeout")
	get_tree().get_root().get_node("Game").lvl_defeated = 2
	song.stop()
	get_tree().get_root().get_node("Game").reset_top()
	print("test")
	self.queue_free()

func create_loading_screen():
	loading = loading_resource.instance()
	loading.global_position.x = get_node("player/camera").global_position.x
	loading.global_position.y = get_node("player/camera").global_position.y
	get_node("../../").add_child(loading)
	
func remove_loading_screen():
	if get_node_or_null("../../loading") != null:
		get_node("../../").remove_child(get_node("loading"))
		get_node("../../loading").queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
