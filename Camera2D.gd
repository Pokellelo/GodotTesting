extends Camera2D

onready var topLeft = $Limits/TopLeft
onready var botRigt = $Limits/BottomRight
func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	
	limit_bottom = botRigt.position.y
	limit_right = botRigt.position.x
