extends Node2D


func _ready():
	pass # Replace with function body.

func _process(delta):
	collide()

func collide():
	if get_node("AnimatedSprite").frame == 4:
		get_node("Area2D/CollisionShape2D").disabled = false
		get_node("AnimatedSprite").playing = false
		yield(get_tree().create_timer(1),"timeout")


func _on_Area2D_body_entered(body):
	if body.is_in_group("item"):
		body.do_add_item()
		#richiama funzione dell'item
