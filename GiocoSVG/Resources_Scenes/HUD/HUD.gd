extends Node2D

var hp = ["res://Resources_Scenes/HUD/Health/0.png","res://Resources_Scenes/HUD/Health/1.png","res://Resources_Scenes/HUD/Health/2.png","res://Resources_Scenes/HUD/Health/3.png"]
var roll = ["res://Resources_Scenes/HUD/Roll/0.png","res://Resources_Scenes/HUD/Roll/1.png","res://Resources_Scenes/HUD/Roll/2.png","res://Resources_Scenes/HUD/Roll/3.png"]
var trow = "res://Resources_Scenes/HUD/Trow/trow.png"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("HpTexture").texture = load(hp[3])
	get_node("RollTexture").texture = load(roll[3])
	get_node("TrowTexture").texture = load(trow)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_hp()
	check_rolls()
	check_trows()
	
func check_hp():
	if Global.plr_health == 3:
		get_node("HpTexture").texture = load(hp[3])
	elif Global.plr_health == 2:
		get_node("HpTexture").texture = load(hp[2])
	elif Global.plr_health == 1:
		get_node("HpTexture").texture = load(hp[1])
	elif Global.plr_health == 0:
		get_node("HpTexture").texture = load(hp[0])
	if get_node("../../").global_position.y < -120:
		global_position.y = -280
	else:
		position.y = -110	

func check_rolls():
	if Global.plr_rolls == 3:
		get_node("RollTexture").texture = load(roll[3])
	elif Global.plr_rolls == 2:
		get_node("RollTexture").texture = load(roll[2])
	elif Global.plr_rolls == 1:
		get_node("RollTexture").texture = load(roll[1])
	elif Global.plr_rolls == 0:
		get_node("RollTexture").texture = load(roll[0])
		
func check_trows():
	get_node("TrowTexture/Label").text = str(Global.plr_trow)
