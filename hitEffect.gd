extends AnimatedSprite




# Called when the node enters the scene tree for the first time.
func _ready():
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0 #para comenzar la animacion desde el fram 1
	play("Animate")
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_animation_finished():
	queue_free()
