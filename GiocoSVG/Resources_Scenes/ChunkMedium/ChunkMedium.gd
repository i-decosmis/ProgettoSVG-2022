extends Node2D

#indica la difficolta' del chunk
var difficulty = 2
#indica il numero del chunk corrente
var chunk_number
#range for spawning platforms in the chunk lvl one
var range_x_y_lvl_one_f = [70,100,-20,-30]
#range for spawning platforms in others chunk lvl one
var range_x_y_lvl_one_up = [-50,-59]
#creation of the random number generator
var rng = RandomNumberGenerator.new()
#path of the terrain
var path_terrain = "res://Resources_Scenes/PlatformTestV2/platform.tscn"
#terrain_resources = path_terrain, loaded path,half_x_terrain,starting_position, terrain_count 
var terrain_resources = [path_terrain, load(path_terrain), 48, Vector2(0,0), 0,]
#array with all the terrains spawned
var terrain = []
#path of the large platform
var path_large_p = "res://Resources_Scenes/FlyingPlatformLarge/floatingPlatform.tscn"
#path of the medium platform
var path_medium_p = "res://Resources_Scenes/FlyingPlatformMedium/floatingPlatform.tscn"
#loaded path of all the platform, plus the current name of the platform
var platform_resource = [load(path_large_p),-1, load(path_medium_p)]
#type of the last platform generated
var platform_type_generated = 0
#array with all the platform spawned
var platform = []
#number of enemys to spawn in this chunk
var spawn_enemy = 0
#last unit on the x axis
var last_unit = 408
#first unit on the x axis of the position of the first terrain
var first_unit_terrain
#spawn or not the boss in this chunk
var spawn_boss = false
#dimensions/2 of the floatin platform large
var half_x_large = Vector2(42,6)
#dimensions/2 of the floatin platform medium
var half_x_medium = Vector2(16,4)
#how many platform to spawn vertically
var p_to_spawn
#starting point for spawn the platforms
var p_from_spawn
#starting platfrom for generate next column
var current_p_from_spawn
#first column of platform to generate
var first_spawn = true
#second column of platfrom to generate
var second_spawn = false
#used to make platfrom spawn up or down
var vertical_spawn = 1
#make platfrom almost always reacheble
var previous_cont = 0
#used to fix platfrom spawned under x = 0
var was_here_under_zero = false
#used to fix platfrom too close to each others
var was_here = false
#used to fix platfrom colliding each others
var test_finished = false
#used to check if the test on the collisions between
var index_platform_to_fix = []
#used to check if there are some platfrom that collide
var platform_to_fix = []
#chunk where to spawn item
var chunk_item_spawn = 3
#if item is spawned
var item_spawned = false
#path to load for item
var item_resource = load("res://Resources_Scenes/Inventory/ItemDrop/ItemFire/ItemFire.tscn")
#item to load in the world
var item

var slime_resources = [load("res://Resources_Scenes/SlimeLightning/Slime.tscn"),"slime",0]

var slime

var hp_resource = load("res://Resources_Scenes/Inventory/ItemDrop/ItemHealth/ItemHealth.tscn")

var hp_spawned = false

var hp

var munition_resource = load("res://Resources_Scenes/Inventory/ItemDrop/ItemMunitions/ItemMunitions.tscn")

var munition_spawned = false

var munition

var spawn_prob = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	chunk_number = get_node("../").chunk_number
	spawn_enemy = get_node("../").spawn_enemy
	last_unit = last_unit + 432 * (chunk_number-1)
	first_unit_terrain = last_unit - 432 - terrain_resources[2]/2
	if chunk_number > 1:
		terrain_resources[3].x = last_unit + terrain_resources[2]
		current_p_from_spawn = get_node("../"+str(chunk_number-1)).current_p_from_spawn
		spawn_boss = get_node("../"+str(chunk_number-1)).spawn_boss
		spawn_enemy = get_node("../"+str(chunk_number-1)).spawn_enemy
	create_chunk()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_chunk():
	create_base_terrain()
	create_platforms_lvl_one()

func create_base_terrain():
	if chunk_number == 1:
		terrain.append(terrain_resources[1].instance())
		terrain[-1].set_name(str(chunk_number)+str(terrain_resources[4]))
		terrain_resources[4] += 1
		terrain[-1].set_position(Vector2(-48,0))
		self.add_child(terrain[-1])
	for n in 9:
		rng.randomize()
		var chanceSpawn
		chanceSpawn = rng.randi_range(1, difficulty)
		if chanceSpawn == 1:
			spawn_one_terrain()
			terrain_resources[4] += 1
		else:
			terrain.append(null)
			terrain_resources[4] += 1
			terrain_resources[3].x += terrain_resources[2]
			
func spawn_one_terrain():
	terrain.append(terrain_resources[1].instance())
	terrain[-1].set_name(str(chunk_number)+str(terrain_resources[4]))
	terrain[-1].set_position(terrain_resources[3])
	self.add_child(terrain[-1])
	terrain_resources[3].x += terrain_resources[2]
	pass	
		
func create_platforms_lvl_one():
	var test
	while true:
		vertical_spawn = 1
		rng.randomize()
		p_to_spawn = rng.randi_range(1,3)
		rng.randomize()
		p_from_spawn = rng.randi_range(1,p_to_spawn)
		test = spawn_platform(p_to_spawn)
		if test != 0:
			break
					
func normalize_platform(var platform_input):
	var half_x
	if platform_type_generated == 0:
		half_x = half_x_large
	else:
		half_x = half_x_medium
	if platform_input.position.x + half_x.x > last_unit:
		return platform_input.position.x + half_x.x - last_unit
	else:
		return 0
func spawn_platform(var p):
	var test
	var spawn = -1
	if previous_cont != 0:
		if previous_cont - p > 1:
			p = p + 1
	for n in p:
		rng.randomize()
		var type = rng.randi_range(0,1)
		if type == 0:
			platform.append(platform_resource[0].instance())
			platform_type_generated = 0
		else:
			platform.append(platform_resource[2].instance())
			platform_type_generated = 1
		platform[-1].set_name(str(chunk_number)+str(platform_resource[1]))
		platform_resource[1] -= 1
		platform[-1].set_position(get_position())
		if spawn_enemy > 0 and chunk_number > 1:
			print("entro")
			rng.randomize()
			spawn = rng.randi_range(spawn_prob,3)
			if spawn == 3:
				spawn_prob = 1
			else:
				spawn_prob += 1
		if spawn == 3:
			spawn_enemy -= 1
			slime = slime_resources[0].instance()
			slime.name = slime_resources[1] + str(slime_resources[2])
			slime_resources[2] += 1
			slime.position.y -= 10
			platform[-1].add_child(slime)
			print(slime.name)
		if chunk_number == 4:
			if !hp_spawned:
				hp_spawned = true
				hp = hp_resource.instance()
				hp.position.y -= 10
				hp.position.x += 5
				platform[-1].add_child(hp)
		if chunk_number % 2 == 0:
			if !munition_spawned:
				munition_spawned = true
				munition = munition_resource.instance()
				munition.position.y -= 10
				munition.position.x -= 5
				platform[-1].add_child(munition)
		self.add_child(platform[-1])
		if chunk_number == chunk_item_spawn and !item_spawned:
			item_spawned = true
			item = item_resource.instance()
			item.position.y = -10
			platform[-1].add_child(item)
		test = normalize_platform(platform[-1])
		if n == 0:
			current_p_from_spawn = platform[-1]
			second_spawn = false
		if test != 0:
			break
	second_spawn = true
	previous_cont = p
	return test
	

func get_position():
	var half_x =  Vector2.ZERO
	if platform_type_generated == 0:
		half_x = half_x_large
	else:
		half_x = half_x_medium
	rng.randomize()
	var offset_x = rng.randi_range(-20,20)
	var position = Vector2.ZERO
	var chance_down = 1
	if first_spawn and chunk_number == 1:
		rng.randomize()
		position.x = 0 + half_x.x +  rng.randi_range(range_x_y_lvl_one_f[0]/2,range_x_y_lvl_one_f[1]/2)
		rng.randomize()
		position.y = 0 - half_x.y +  rng.randi_range(range_x_y_lvl_one_f[2],range_x_y_lvl_one_f[3])
		first_spawn = false
	elif first_spawn:
		first_spawn = false
		if current_p_from_spawn.position.y < -140:
			chance_down = -1.5
		if current_p_from_spawn.position.y > -50:
			chance_down = 1
		rng.randomize()
		position.x = current_p_from_spawn.position.x + half_x.x + rng.randi_range(range_x_y_lvl_one_f[0],range_x_y_lvl_one_f[1])
		rng.randomize()
		position.y = current_p_from_spawn.position.y + rng.randi_range(range_x_y_lvl_one_f[2],range_x_y_lvl_one_f[3]) * chance_down
	elif second_spawn:
		if current_p_from_spawn.position.y < -140:
			chance_down = -1.5
		if current_p_from_spawn.position.y > -50:
			chance_down = 1
		rng.randomize()
		position.x = current_p_from_spawn.position.x + half_x.x + rng.randi_range(range_x_y_lvl_one_f[0],range_x_y_lvl_one_f[1])
		rng.randomize()
		position.y = current_p_from_spawn.position.y + rng.randi_range(range_x_y_lvl_one_f[2],range_x_y_lvl_one_f[3]) * chance_down
	else:
		if platform[-2].position.y < -140:
			vertical_spawn = -1
		if vertical_spawn == -1:
			if was_here:
				rng.randomize()
				position.x = platform[-2].position.x + offset_x
				rng.randomize()
				position.y = platform[-2].position.y + rng.randi_range(range_x_y_lvl_one_up[0],range_x_y_lvl_one_up[1])
			else:
				rng.randomize()
				position.x = current_p_from_spawn.position.x + offset_x
				rng.randomize()
				position.y = current_p_from_spawn.position.y + rng.randi_range(range_x_y_lvl_one_up[0],range_x_y_lvl_one_up[1]) * vertical_spawn
				rng.randomize()
				if position.y > 0:
					rng.randomize()
					was_here_under_zero = true
					position.y = 0
					position.y += rng.randi_range(range_x_y_lvl_one_f[2],range_x_y_lvl_one_f[3])
				elif position.y > -10:
					if was_here_under_zero:
						position.y = platform[-2].position.y + rng.randi_range(range_x_y_lvl_one_up[0],range_x_y_lvl_one_up[1])
					else:
						was_here_under_zero = true
						position.y += rng.randi_range(-12,-20)
				was_here = true
		else:
			rng.randomize()
			position.x = platform[-2].position.x + offset_x
			rng.randomize()
			position.y = platform[-2].position.y + rng.randi_range(range_x_y_lvl_one_up[0],range_x_y_lvl_one_up[1]) * vertical_spawn
	return position

