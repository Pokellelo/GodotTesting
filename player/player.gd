extends KinematicBody2D


export var ACCEL = 500
export var MAX_SPEED = 80
export var FRICTION = 500
export var rollSpeed = 95

var velocity = Vector2.ZERO
var rollVector = Vector2.DOWN
#var animationplayer = null
enum {
	MOVE,
	SHRIK,
	ATTACK
}
var state = MOVE

var stats = PlayerStats

onready var animationplayer = $AnimationPlayer
onready var animationTree  = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var sprite2 = $Sprite2
onready var hurtbox = $Hurtbox
onready var handHitbox = $hitboxpivot/swordhitbox
const player_hurtSound	= preload("res://playerHurtSound.tscn")
onready var blinkAnimationlayer = $BlinkAnimation
#func _ready():
#	animationplayer= $AnimationPlayer
	
	
	
func _ready():
	animationTree.active = true
	handHitbox.knockback_vector = rollVector
	stats.connect("no_health", self, "queue_free" )
	
func _physics_process(delta): #Espera para cargas
#func _process(delta): 
	match state:
		MOVE:
			move_state(delta)
			
		SHRIK:
			roll_state()
			
		ATTACK:
			attack_state()
	
	
func move_state(delta):
	#if Input.is_action_pressed("ui_right"):
	#	$Sprite3.visible = true
	#	$Sprite.visible = false
	#	$Sprite2.visible = false
	#	animationplayer.play("attac")
	#else:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("key_right") - Input.get_action_raw_strength("key_left")
	input_vector.y = Input.get_action_strength("key_down") - Input.get_action_raw_strength("key_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		rollVector = input_vector
		handHitbox.knockback_vector = input_vector
		animationTree.set("parameters/BlendSpace2D/blend_position", input_vector) #moving
			#if input_vector.x > 0:
		animationplayer.play("run_right")
			#else:
				#animationplayer.play("run_right") #run_left
			#velocity += input_vector * ACCEL * delta
			#velocity = velocity.clamped(MAX_SPEED)
			#animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)
		$Sprite.visible = true
		$Sprite2.visible = false
		$Sprite3.visible = false
		$Sprite4.visible = false
		#animationplayer.stop()
	else:
			#animationState.travel("idle")
			#animationTree.set("parameters/BlendSpace2D/blend_position", input_vector) #iidle
		animationplayer.play("idle")
			
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		$Sprite.visible = false
		$Sprite2.visible = true
		$Sprite3.visible = false
		$Sprite4.visible = false
		#move_and_collide(velocity * delta)
	move()#ya no es necesario multiplicar velocidad x delta

	if Input.is_action_just_pressed("ui_down"):
		#layerStats.max_health -= 1
		state = SHRIK
		
	if Input.is_action_just_pressed("ui_right"):
		state = ATTACK
		
		
		
func attack_state():
	$Sprite.visible = false
	$Sprite2.visible = false
	$Sprite3.visible = true
	$Sprite4.visible = false
	velocity = Vector2.ZERO
	animationplayer.play("attac")
	
	
func roll_state():
	$Sprite.visible = false
	$Sprite2.visible = false
	$Sprite3.visible = false
	$Sprite4.visible = true
	velocity = rollVector * rollSpeed
	animationplayer.play("Roll")
	move()

func move():
	velocity = move_and_slide(velocity)
	
func attackEnd():
	state = MOVE
	
func rollEnd():
	#velocity = change if want to reduce sliding after finish
	state = MOVE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hitEffect()
	var playerHurtSound = player_hurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	
	


func _on_Hurtbox_invincibility_started():
	blinkAnimationlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationlayer.play("Stop")
