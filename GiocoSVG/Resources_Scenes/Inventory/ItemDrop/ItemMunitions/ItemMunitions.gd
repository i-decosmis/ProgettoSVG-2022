extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
var item_name
var is_in = false
var is_colliding_moving_p = false
var p_area = null

func _ready():
	item_name = "Water"
	
	
func _process(delta):
	if is_in == true:
		do_add_item()

	
func _physics_process(delta):
	velocity = velocity.move_toward(Vector2(0, MAX_SPEED), ACCELERATION * delta)
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		is_in = true
	if area.is_in_group("platform"):
		p_area = area
func _on_Area2D_area_exited(area):
	if area.is_in_group("player"):
		is_in = false
		print(is_in)

func do_add_item():
	Global.plr_trow = 10
	self.queue_free()

func move_with_platform():
	if is_colliding_moving_p == true:
		if p_area != null:
			if p_area.get_node("../").is_moving == "left":
				self.position.x -= 1
			else:
				self.position.x += 1
