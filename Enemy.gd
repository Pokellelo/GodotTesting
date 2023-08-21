extends KinematicBody2D

const EnemyDeathEffect = preload("res://enemydeathEffect.tscn")

var knockback = Vector2.ZERO

onready var stats = $Stats
onready var playerDetectionZone = $Area2D
onready var sprite = $Sprite
onready var hurtbox = $Hurtbox
onready var softCol = $SoftCollision
onready var animationPlayer = $AnimationPlayer
#func _ready():
#	print(stats.max_health)
#	print(stats.health)
#
#func _physics_process(delta):
#	knockback = knockback.move_toward(Vector2.ZERO, 120 * delta)
#	knockback = move_and_slide(knockback)
#
#func _on_Hurtbox_area_entered(area):
#	#var knockback_vector = area.knockback_vector
#	stats.health -= area.damage
##	if(stats.health <= 0): when you go up the tree use a signal
##		queue_free()
#	knockback = area.knockback_vector * 50
#

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

const KNOCKBACK_SPEED := 170
const KNOCKBACK_FRICTION := 350

var knockback_direction := Vector2.ZERO
var knockback_velocity := Vector2.ZERO


var velocity = Vector2.ZERO
export var accel = 300

export(int) var wanderTarget_range = 4

export var max_speed = 50
export var friction = 200

onready var position_spawned = global_position
onready var wanderController = $WanderCtr
func _ready():
	sprite.frame = rand_range(0, 3)
	randomize()
	state = pick_random_state([IDLE, WANDER ])

func _physics_process(delta) -> void:
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	knockback_velocity = move_and_slide(knockback_velocity)
	
	match state:
		
		IDLE:
			#velocity = velocity.move_toward(position_spawned, 200 * delta)
			
			#velocity = velocity.move_toward(global_position.direction_to(position_spawned) * max_speed, accel * delta)
			
			velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
#
#			if velocity != velocity:
#				sprite.flip_h = velocity.x < 0
#			else:
#				sprite.flip_h = false
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()			
			accelerate_toward(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= wanderTarget_range: #maybe max_speed * delta ?
				update_wander()

		CHASE:
			var player = playerDetectionZone.player
			
			if player != null:
				accelerate_toward(player.global_position, delta)
			else:
				state = IDLE

			
	if softCol.is_collidin():
		velocity+= softCol.get_push_vector() * delta * 400	
	velocity = move_and_slide(velocity)

func accelerate_toward(point, delta):
	velocity = velocity.move_toward(global_position.direction_to(point) * max_speed, accel * delta)
	sprite.flip_h = velocity.x < 0
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,3))
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area) -> void:
	stats.health -= area.damage
	knockback_direction = get_node("Hurtbox").global_position - area.global_position
	knockback_direction = knockback_direction.normalized()
	knockback_velocity = knockback_direction * KNOCKBACK_SPEED
	hurtbox.create_hitEffect()
	hurtbox.start_invincibility(0.4)


func _on_Stats_no_health():
	queue_free()
	var enemyDeatEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeatEffect)
	enemyDeatEffect.global_position = global_position


func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")
