extends StaticBody2D

var type = "small"
var enemy = "free"
var start = null
var timer
var body_entered
var song = AudioStreamPlayer2D.new()
var song_load = load("res://Resources_Scenes/Audio/burning_platform.wav")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	song.stream = song_load
	song.set_volume_db(-13)
	self.add_child(song)
	if get_node("../../").difficulty == 3:
		get_node("CollisionPolygon2D2/Polygon2D").texture = load("res://Resources_Scenes/FlyingPlatformSmall/floating_platform_small_three.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if start != null:
		timer = OS.get_ticks_msec()
		if timer - start >=2000:
			Global.plr_health -= 1
			if Global.plr_health <= 0:
				body_entered.die()
			start = OS.get_ticks_msec()


func _on_Area2D_area_entered(area):
	if area.get_node("../").has_method("get_platform_type"):
		print(area.get_node("../").name)
		print(self.name)
		print("posizione",area.get_node("../").position.y)
		self.position.y = self.position.y + 25
		self.position.x = self.position.x + 25
		print(area.get_node("../").position.y)
		area.free()


func get_platform_type():
	return type


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		start = OS.get_ticks_msec()
		song.play()
		body_entered = body


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		song.stop()
		body = null
		start = null
