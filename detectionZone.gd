extends Area2D

var player = null


func can_see_player():
	return player != null


func _on_Area2D_body_entered(body):
	player = body


func _on_Area2D_body_exited(_body):
	player = null
