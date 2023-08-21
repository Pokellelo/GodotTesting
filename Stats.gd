extends Node
#el typeo es opcional
export(int) var max_health =  1 setget set_max_health

var health = max_health setget set_health
	
#func _process(delta):
#	if health <= 0:  NO, checar cosas cada frame
#		emit_signal("no_health")
signal no_health 
signal max_health_change(value)
signal health_change(value)

func set_health(value):
	health = value
	emit_signal("health_change", health)
	if health <= 0:
		emit_signal("no_health")
	
func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_change", max_health)
	
func _ready():
	self.health = max_health
