extends Node2D


const GrassEffect = preload("res://GrassEffect.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func create_grass_effect():
	
	#if Input.is_action_just_pressed("ui_right"):
	#var GrassEffect = load("res://GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	#var main = get_tree().current_scene
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position
	queue_free()  #Free function deletes rightaway - que waits for the end of the frame


func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
	
