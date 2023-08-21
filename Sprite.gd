extends Sprite

var angular_speed = PI
var speed = 400.0

func _process(delta):

	var direction = 0
	var velocity = Vector2.ZERO
	
	#if Input.is_action_pressed("ui_left"):
	#	rotation_degrees = -90
	
	#rotation += angular_speed * direction * delta
	
	if Input.is_action_pressed("ui_right"):
		print (rotation_degrees)
		
		if (rotation_degrees >= 0 && rotation_degrees < 90):
			rotation_degrees += 5
			if rotation_degrees > 90:
				rotation_degrees = 90
				
		if (rotation_degrees < 0):
			rotation_degrees += 10
			if rotation_degrees > 90:
				rotation_degrees = 90
		
		if rotation_degrees > 90 && rotation_degrees <= 180:
			print("Hola")
			rotation_degrees -= 5
			if rotation_degrees < 90:
				rotation_degrees = 90
		

		#velocity = Vector2.UP.rotated(rotation_degrees) * speed
		velocity += Vector2.RIGHT * speed

		
	if Input.is_action_pressed("ui_left"):
		if rotation_degrees > -90:
			rotation_degrees -= 10
		else:
			rotation_degrees = -90
		velocity = Vector2.LEFT * speed
		
	if Input.is_action_pressed("ui_up"):
		
		if rotation_degrees > 0:
			rotation_degrees -= 10
		else:
			rotation_degrees = 0
			
		if rotation_degrees < 0:
			rotation_degrees += 10
		else:
			rotation_degrees = 0
			
		velocity = Vector2.UP * speed
		
	if Input.is_action_pressed("ui_down"):
		rotation_degrees = 180
		#print (rotation_degrees)
		velocity = Vector2.DOWN * speed
		

#	var velocity = Vector2.UP.rotated(rotation) * speed
	position += velocity * delta #Vector2.RIGHT * speed * delta
