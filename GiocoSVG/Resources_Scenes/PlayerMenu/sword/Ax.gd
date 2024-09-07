extends Area2D

var movable = true
var speed
var rot_speed = 15

func _physics_process(delta):
	if movable == true:
		position.x += speed * delta
	rotate(deg2rad(15))
	
func _ready():
	if Global.plr_flipped == false:
		speed = 300
	elif Global.plr_flipped == true:
		speed= -300
	rot_speed = 15

func _on_Ax_body_entered(body):
	if body.is_in_group("enemy"):
		#Global.boss_health-=1
		speed = 0
		position = body.global_position
		rot_speed=0
		movable = false


func remove():
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
