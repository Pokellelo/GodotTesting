extends Area2D

var hitEffect = preload("res://hitEffect.tscn")

#export (bool) var show_hit = true
var invencible = false setget set_invencible

onready var timer = $Timer
onready var collision_shape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended
	
func create_hitEffect():
	var effect = hitEffect.instance()
	var main = get_tree().current_scene	
	main.add_child(effect)
	effect.global_position = global_position

func start_invincibility(duration):
	self.invencible = true
	timer.start(duration)

func set_invencible(value):
	invencible = value
	if invencible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func _on_Timer_timeout():
	self.invencible = false

func _on_Hurtbox_invincibility_started():
	#set_deferred("monitoring", false)
	collision_shape.set_deferred("disabled", true)

	
func _on_Hurtbox_invincibility_ended():
	#monitoring = true
	collision_shape.set_deferred("disabled", false)



	#monitorable = true
