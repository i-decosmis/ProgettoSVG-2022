extends Node2D


var chunk_resource = load("res://Resources_Scenes/ChunkMedium/ChunkMedium.tscn")
var chunk = []
var chunk_number = 1
var chunk_to_load = 7
var player_resource = load("res://Resources_Scenes/Player/Player.tscn")
var player_node
var player_position = Vector2(1,1)
var inventory_resource = load("res://Resources_Scenes/Inventory/Inventory.tscn")
var inventory
var camera = Camera2D.new()
var camera_offset = -60
var difficulty = 2
var spawn_enemy = 3
var rng = RandomNumberGenerator.new()
var song = AudioStreamPlayer2D.new()
var tree_resource = load("res://Resources_Scenes/StartingPoint/TreeLvTwo/TreeLvTwo.tscn")
var tree_position = Vector2(1,1)
var tree_node
var portal_resource = load("res://Resources_Scenes/Portals/PortalTwo/Portal.tscn")
var portal
var hud_resource = load("res://Resources_Scenes/HUD/HUD.tscn")
var hud
var loading_resource = load("res://Resources_Scenes/Loading Text/LoadingText.tscn")
var loading
# Called when the node enters the scene tree for the first time.
func _ready():
	create_chunk()
	create_player()
	create_camera()
	create_song()
	create_three()
	create_portal()
	create_hud()
	remove_loading_screen()

func create_chunk():
	for n in chunk_to_load:
		if n > 1:
			rng.randomize()
			spawn_enemy = rng.randi_range(3,4)
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
	camera.name = "camera"
	get_node("player").add_child(camera)
	camera.current = true	

func create_song():
	song.stream = load("res://Resources_Scenes/Audio/mountain.wav")
	song.autoplay = true
	get_node("player").add_child(song)	

func create_three():
	tree_node = tree_resource.instance()
	tree_node.position = get_node("1/10").get_position()
	#tree_node.position.y -= 6
	tree_node.position.x -= 2
	tree_node.scale = tree_node.scale * 8
	self.add_child(tree_node)
	
func create_portal():
	portal = portal_resource.instance()
	portal.position.x = get_node(str(chunk_to_load)).platform[-1].position.x + 30
	portal.position.y = get_node(str(chunk_to_load)).platform[-1].position.y - 30
	self.add_child(portal)

func create_hud():
	hud = hud_resource.instance()
	hud.scale.x = 0.5
	hud.scale.y = 0.5
	hud.position.x = -190
	hud.position.y = -110
	get_node("player/camera").add_child(hud)

func end_level():
	song.stop()
	#create_loading_screen()
	yield(get_tree().create_timer(0.1),"timeout")
	get_node("../Menu").lvl_defeated = 2
	var three_resource = load("res://Scenes/WorldHard/WorldHard.tscn")
	var three = three_resource.instance()
	three.set_name("world")
	get_node("../").add_child(three)
	self.queue_free()
	
func reset_level():
	yield(get_tree().create_timer(0.1),"timeout")
	get_tree().get_root().get_node("Game").lvl_defeated = 1
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
	
