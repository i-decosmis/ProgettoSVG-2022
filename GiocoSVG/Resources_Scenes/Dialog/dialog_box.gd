extends Node2D
var pos
export (Array, String, MULTILINE) var arr
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pos = 0
	if arr.size() == 0:
		arr.append("error, no text!")
	change_text()
	change_size()
	$AnimationPlayer.play("open")
	
func change_text():
	if arr.size() == 0:
		get_parent().remove_child(self)
		return
	$Control/Label.text = self.arr[pos]
	#arr.pop_front()
	
func next_text():
	if pos == 0:
		pos += 1
		print(arr.size())
		$Control/Label.text = self.arr[-1]
	else:
		$Control/Label.hide()
		$Button.hide()
	
	
func change_size():
	$Control/Label.rect_size = Vector2(0,0)
	$Control/Label.margin_top = 0
	$Control/Label.margin_bottom = 0
	

#func _on_Button_pressed():
	#next_text()
	#change_size()


func _on_TextureButton_pressed():
	next_text()
	change_size()
