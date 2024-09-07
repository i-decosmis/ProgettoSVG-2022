extends Node2D

var chunk_resource = load("res://Resources_Scenes/ChunkEasy/ChunkEasy.tscn")
var chunk = []
var chunk_number = 1
var chunk_to_load = 5
var player_resource = load("res://Resources_Scenes/Player/Player.tscn")
var player_node
var player_position = Vector2(1,1)
var inventory_resource = load("res://Resources_Scenes/Inventory/Inventory.tscn")
var inventory
var tree_resources = [load("res://Resources_Scenes/StartingPoint/Tree/Tree.tscn"),Vector2(1,1)]
var tree_node
var camera = Camera2D.new()
var camera_offset = -60
var song = AudioStreamPlayer2D.new()
var song_resources = [load("res://Resources_Scenes/Audio/woods.wav")]
var portal_resource = load("res://Resources_Scenes/Portals/PortalOne/Portal.tscn")
var portal
var hud_resource = load("res://Resources_Scenes/HUD/HUD.tscn")
var hud
var difficulty = 1
var spawn_enemy = 1
var rng = RandomNumberGenerator.new()
var loading_resource = load("res://Resources_Scenes/Loading Text/LoadingText.tscn")
var loading
var tutorial_movimento_resource = load("res://Resources_Scenes/Tutorial/Movement.tscn")
var tutorial_movimento
var tutorial_combattimento_resource = load("res://Resources_Scenes/Tutorial/Combat.tscn")
var tutorial_combattimento
var tutorial_rope_resource = load("res://Resources_Scenes/Tutorial/Rope.tscn")
var tutorial_rope
var tutorial_dmg_resource = load("res://Resources_Scenes/Tutorial/Dmg.tscn")
var tutorial_dmg
var tutorial_esc_resource = load("res://Resources_Scenes/Tutorial/Esc.tscn")
var tutorial_esc
var dialog_resource = load("res://Resources_Scenes/Dialog/dialog_box.tscn")
var dialog
var rope_loaded = false
var movement_loaded = false
var combat_loaded = false
var dmg_loaded = false
var esc_loaded = false


func _process(delta):
	load_tutorial()

# Called when the node enters the scene tree for the first time.
func _ready():
	create_chunks()
	create_player()
	create_dialog()
	create_camera()
	create_song()
	create_tree()
	create_hud()
	create_portal()

func create_chunks():
	for n in chunk_to_load:
		if n > 2:
			rng.randomize()
			spawn_enemy = rng.randi_range(2,4)
		chunk.append(chunk_resource.instance())
		chunk[-1].set_name(str(n+1))
		self.add_child(chunk[-1])
		chunk_number += 1
		
func create_player():
	player_node = player_resource.instance()
	if get_node("1/10") == null:
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
	camera.limit_bottom = 53
	camera.limit_top = -300
	camera.current = true
	camera.name = "camera"
	get_node("player").add_child(camera)

func create_song():
	song.stream = song_resources[0]
	song.autoplay = true
	get_node("player").add_child(song)

func create_tree():
	tree_node = tree_resources[0].instance()
	tree_node.position = get_node("1/10").get_position()
	tree_node.position.y -= 6
	tree_node.position.x += 6
	tree_node.scale = tree_node.scale * 8
	self.add_child(tree_node)
	
func create_hud():
	hud = hud_resource.instance()
	hud.scale.x = 0.5
	hud.scale.y = 0.5
	hud.position.x = -190
	hud.position.y = -110
	get_node("player/camera").add_child(hud)

func create_portal():
	portal = portal_resource.instance()
	portal.position.x = get_node(str(chunk_to_load)).platform[-1].position.x + 30
	portal.position.y = get_node(str(chunk_to_load)).platform[-1].position.y - 30
	self.add_child(portal)

func end_level():
	song.stop()
	yield(get_tree().create_timer(0.1),"timeout")
	get_node("../Menu").lvl_defeated = 1
	var two_resource = load("res://Scenes/WorldMedium/WorldMedium.tscn")
	var two = two_resource.instance()
	two.set_name("world")
	get_node("../").add_child(two)
	self.queue_free()
	
func reset_level():
	yield(get_tree().create_timer(0.1),"timeout")
	get_tree().get_root().get_node("Game").lvl_defeated = 0
	song.stop()
	get_tree().get_root().get_node("Game").reset_top()
	print("test")
	self.queue_free()

func create_loading_screen():
	loading = loading_resource.instance()
	loading.global_position.x = get_node("player/camera").global_position.x
	loading.global_position.y = get_node("player/camera").global_position.y
	loading.name = "loading"
	get_node("../../").add_child(loading)
	
func load_tutorial():
	if get_node("player").position.x < 260:
		if combat_loaded:
			get_node("player/Combat").queue_free()
			combat_loaded = false
		if !movement_loaded:
			movement_loaded = true
			tutorial_movimento = tutorial_movimento_resource.instance()
			get_node("player").add_child(tutorial_movimento)
	elif get_node("player").position.x > 260 and get_node("player").position.x < 550:
		if movement_loaded:
			get_node("player/Movement").queue_free()
			movement_loaded = false
		if rope_loaded:
			get_node("player/RopeTutorial").queue_free()
			rope_loaded = false
		if !combat_loaded:
			tutorial_combattimento = tutorial_combattimento_resource.instance()
			get_node("player").add_child(tutorial_combattimento)
			combat_loaded = true
	elif get_node("player").position.x > 500 and get_node("player").position.x < 900:
		if combat_loaded:
			get_node("player/Combat").queue_free()
			combat_loaded = false
		if dmg_loaded:
			get_node("player/DmgTutorial").queue_free()
			dmg_loaded = false
		if !rope_loaded:
			tutorial_rope = tutorial_rope_resource.instance()
			get_node("player").add_child(tutorial_rope)
			rope_loaded = true
	elif get_node("player").position.x > 900 and get_node("player").position.x < 1300:
		if rope_loaded:
			get_node("player/RopeTutorial").queue_free()
			rope_loaded = false
		if esc_loaded:
			get_node("player/EscTutorial").queue_free()
			esc_loaded = false		
		if !dmg_loaded:
			tutorial_dmg = tutorial_dmg_resource.instance()
			get_node("player").add_child(tutorial_dmg)
			dmg_loaded = true
	elif get_node("player").position.x > 1300 and get_node("player").position.x < 1900:
		if dmg_loaded:
			get_node("player/DmgTutorial").queue_free()
			dmg_loaded = false
		if !esc_loaded:
			tutorial_esc = tutorial_esc_resource.instance()
			get_node("player").add_child(tutorial_esc)
			esc_loaded = true	
	elif get_node("player").position.x > 1900:
		if esc_loaded:
			get_node("player/EscTutorial").queue_free()
			esc_loaded = false

func create_dialog():
	dialog = dialog_resource.instance()
	get_node("player").add_child(dialog)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
