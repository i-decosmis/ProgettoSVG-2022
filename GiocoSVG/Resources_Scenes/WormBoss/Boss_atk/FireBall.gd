extends Area2D

var movable = true
var speed


func _physics_process(delta):
	if movable == true:
		position.x += speed * delta
		

func _ready():
	if Global.worm_boss_flipped == true:
		$AnimatedSprite.flip_h=false
		$AnimatedSprite.play("Fireball")
		speed = 100
	elif Global.worm_boss_flipped == false:
		$AnimatedSprite.flip_h=true
		$AnimatedSprite.play("Fireball")
		speed= -100
		
func _on_FireBall_body_entered(body):
	if body.is_in_group("player"):
		speed = 0
		position = body.global_position
		movable = false
		$AnimatedSprite.play("Explosion")
		yield(get_tree().create_timer(1.2), "timeout")

func remove():
	yield(get_tree().create_timer(0.6), "timeout")
	queue_free()
