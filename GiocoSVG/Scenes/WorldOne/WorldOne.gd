extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_platform = 0
var half_dim_platform = 8
var pos =  Vector2.ZERO
var path = "res://Resources_Scenes/PlatformTest/platform.tscn"
var scene_resource = load(path)
var scene0
var scene1
var scene2
var scene3
var scene4
var scene5
var scene6
var middle = 3
var zero = 0
var scene_list = [scene0,scene1,scene2,scene3,scene4,scene5,scene6]
var mod
# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_terrain()
	pass # Replace with function body.

func generate_first_flat_terrain(var scene, var name):
	scene.set_name(name)
	scene.position.x = 0
	scene.position.y = 0 + 8
	scene.scale.x = 6
	scene.scale.y = 6
	pass
func generate_first_flat_terrain_right(var scene, var index, var name):
	
	mod.set_name("test")
	
	scene.set_name(name)
	var points
	if index == 1:
		points = get_node(scene_list[3].name+"/CollisionPolygon2D/Polygon2D").get_polygon()
	else:
		points = get_node(scene_list[4].name+"/CollisionPolygon2D/Polygon2D").get_polygon()
	scene.position.x = 0 + (points[1].x * 6 + half_dim_platform * 6) * index
	scene.position.y = 0 + 8
	scene.scale.x = 6
	scene.scale.y = 6
	
	mod.position.x = 0 + (points[1].x * 6 + half_dim_platform * 6) * index
	mod.position.y = 0 - 16
	mod.scale.x = 6
	mod.scale.y = 6
	self.add_child(mod)
	pass
	
func generate_first_flat_terrain_left(var scene, var index, var name):
	scene.set_name(name)
	var points
	if index == -1:
		points = get_node(scene_list[3].name+"/CollisionPolygon2D/Polygon2D").get_polygon()
	else:
		points = get_node(scene_list[2].name+"/CollisionPolygon2D/Polygon2D").get_polygon()
	scene.position.x = 0 - (points[0].x * 6 - half_dim_platform * 6) * index 
	scene.position.y = 0 + 8
	scene.scale.x = 6
	scene.scale.y = 6
	pass
	
func initialize_terrain():
	var cont = 2
	scene_list[middle] = scene_resource.instance()
	
	mod = scene_resource.instance()
	
	generate_first_flat_terrain(scene_list[middle],str(zero))
	self.add_child(scene_list[middle])
	var j = -1
	while j > -4:
		scene_list[cont] = scene_resource.instance()
		generate_first_flat_terrain_left(scene_list[cont], j,str(j))
		self.add_child(scene_list[cont])
		cont -= 1
		j -= 1
	cont = 4
	for i in range(1,4):
		scene_list[cont] = scene_resource.instance()
		generate_first_flat_terrain_right(scene_list[cont], i,str(i))
		self.add_child(scene_list[cont])
		cont += 1
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func _process(delta):

	pos = get_node("Player").position
	if int(pos.x) >= 96 * current_platform:
		update_terrain("r")
		current_platform += 1
	elif  int(pos.x) <= 96 * current_platform:
		update_terrain("l")
		current_platform -= 1
	pass

func update_terrain(var dir):
	if dir == "r":
		update_terrain_right()
	else:
		update_terrain_left()
	pass

func update_terrain_right():
	scene_list[0].queue_free()
	for i in range(0,6):
		scene_list[i] = scene_list[i + 1]
	scene_list[6] = scene_resource.instance()
	generate_flat_terrain_right(scene_list[6])
	self.add_child(scene_list[6])
	pass

func update_terrain_left():
	scene_list[6].queue_free()
	var i = 6
	while i > 0:
		scene_list[i] = scene_list[i - 1]
		i -= 1
	scene_list[0] = scene_resource.instance()
	generate_flat_terrain_left(scene_list[0])
	self.add_child(scene_list[0])
	pass
	
func generate_flat_terrain_right(var scene):
	var name = str(int(scene_list[5].name) + 1)
	scene.set_name(name)
	var points
	points = get_node(scene_list[5].name+"/CollisionPolygon2D/Polygon2D").get_polygon()
	scene.position.x = 0 + (points[1].x * 6 + half_dim_platform * 6) * int(name)
	scene.position.y = 0 + 8
	scene.scale.x = 6
	scene.scale.y = 6
	pass
	
func generate_flat_terrain_left(var scene):
	var name = str(int(scene_list[1].name) - 1)
	scene.set_name(name)
	var points
	points = get_node(scene_list[1].name+"/CollisionPolygon2D/Polygon2D").get_polygon()
	scene.position.x = (points[0].x * 6 - half_dim_platform * 6) * (-int(name))
	scene.position.y = 0 + 8
	scene.scale.x = 6
	scene.scale.y = 6
	pass
