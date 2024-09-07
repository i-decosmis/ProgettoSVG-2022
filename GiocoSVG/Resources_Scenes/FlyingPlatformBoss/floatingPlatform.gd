extends StaticBody2D

var type = "boss"
var enemy = "free"
var boss_spawn_resource = load("res://Resources_Scenes/WormBoss/Worm.tscn")
var boss_spawn
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.remove_child(get_node("worm"))
	boss_spawn = boss_spawn_resource.instance()
	boss_spawn.name = "worm"
	boss_spawn.position.x = 430
	boss_spawn.position.y = -19
	boss_spawn.scale.x = 0.6
	boss_spawn.scale.y = 0.6
	self.add_child(boss_spawn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

