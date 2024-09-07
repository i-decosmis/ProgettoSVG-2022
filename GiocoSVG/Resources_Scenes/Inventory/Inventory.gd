extends Node2D

var fire_not_resource = load("res://Resources_Scenes/HUD/Change_Type/fire.tscn")
var water_not_resource = load("res://Resources_Scenes/HUD/Change_Type/water.tscn")
var lightning_not_resource = load("res://Resources_Scenes/HUD/Change_Type/lightning.tscn")
var normal_not_resource = load("res://Resources_Scenes/HUD/Change_Type/normal.tscn")

var fire_not
var water_not
var lightning_not
var normal_not

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	show_inventory()
	controller()
	exit_save()

		
func show_inventory():
	if Input.is_action_just_pressed("Inventory"):
		visible = !visible	
		
func controller():
	if Input.is_action_just_pressed("power_swap"):
		if Global.type_used == "normal":
			if Global.lightning_active:
				Global.type_used = "lightning"
				lightning_not = lightning_not_resource.instance()
				get_node("../").add_child(lightning_not)
			else:
				Global.type_used = "normal"
				normal_not = normal_not_resource.instance()
				get_node("../").add_child(normal_not)
		elif Global.type_used == "lightning":
			if Global.fire_active:
				Global.type_used = "fire"
				fire_not = fire_not_resource.instance()
				get_node("../").add_child(fire_not)
			else:
				Global.type_used = "normal"
				normal_not = normal_not_resource.instance()
				get_node("../").add_child(normal_not)
		elif Global.type_used == "fire":
			if Global.water_active:
				Global.type_used = "water"
				water_not = water_not_resource.instance()
				get_node("../").add_child(water_not)
			else:
				Global.type_used = "normal"
				normal_not = normal_not_resource.instance()
				get_node("../").add_child(normal_not)
		elif Global.type_used == "water":
			Global.type_used = "normal"
			normal_not = normal_not_resource.instance()
			get_node("../").add_child(normal_not)

func exit_save():
	if Input.is_action_just_pressed("save") and visible:
		pass #richiamare qui funzione di salvataggio: get_node("GridContainer/Save").save()
	elif Input.is_action_just_pressed("exit") and visible:
		get_node("GridContainer/Exit").exit()
