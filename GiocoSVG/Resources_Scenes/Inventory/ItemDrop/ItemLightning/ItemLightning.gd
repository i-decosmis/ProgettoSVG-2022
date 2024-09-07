extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
var item_name
var is_in = false

func _ready():
	item_name = "Lightning"
	
	
func _process(delta):
	if is_in == true:
		do_add_item()

	
func _physics_process(delta):
	velocity = velocity.move_toward(Vector2(0, MAX_SPEED), ACCELERATION * delta)
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		is_in = true

func _on_Area2D_area_exited(area):
	if area.is_in_group("player"):
		is_in = false
		print(is_in)

func do_add_item():
	Global.lightning_active = true
	self.queue_free()
