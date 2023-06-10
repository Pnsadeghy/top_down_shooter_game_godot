extends Node2D

class_name EnemyAI

signal on_state_changed(state: Constants.EnemyAIStates)

@export var weapon: Weapon
@export var character: CharacterBody2D
@export var move_speed := 75
@export var max_distance := 200

var current_state: Constants.EnemyAIStates
var target = null
var movement_vector = Vector2.LEFT

var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached := true
var patrol_move_direcrion: Vector2
var patrol_move_rotation

@onready var detection_zone: Area2D = $DetectionZone
@onready var follow_zone: Area2D = $FollowZone
@onready var patrol_timer: Timer = $PatrolTimer
@onready var wall_checker: RayCast2D = $WallChecker

func _ready():
	randomize()
	detection_zone.body_entered.connect(on_target_detection)
	follow_zone.body_entered.connect(on_target_looking_detection)
	follow_zone.body_exited.connect(on_target_lost)
	set_state(Constants.EnemyAIStates.PATROL)

func _process(delta):
	match current_state:
		Constants.EnemyAIStates.PATROL:
			if !patrol_location_reached:
				if character.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					character.velocity = Vector2.ZERO
					$PatrolTimer.start()
				else:
					character.velocity = patrol_move_direcrion
					character.rotation = lerp_angle(character.rotation, patrol_move_direcrion.angle(), 0.01)
			pass
		Constants.EnemyAIStates.ENGAGE:
			var angle_to_target = character.global_position.direction_to(target.global_position).angle()
			character.rotation = lerp_angle(character.rotation, angle_to_target, 0.1)
			
			if abs(angle_to_target - character.rotation) < 0.1:
				if weapon.can_shoot():
					weapon.shoot()
			
			#if character.global_position.distance_to(target.global_position) > max_distance:	
			#	character.velocity = (target.global_position - character.global_position).normalized() * move_speed
			#elif target.velocity.length() > 0:
			#	character.velocity = (character.global_position - target.global_position).normalized() * move_speed
			#else:
			#	character.velocity = Vector2.ZERO

			pass
			
func _physics_process(delta):
	match current_state:
		Constants.EnemyAIStates.PATROL:
			if !patrol_location_reached:
				character.move_and_slide()
			pass
		Constants.EnemyAIStates.ENGAGE:
			character.move_and_slide()
			pass

func set_state(state: Constants.EnemyAIStates):
	if current_state == state: return
	character.velocity = Vector2.ZERO
	
	if state == Constants.EnemyAIStates.PATROL:
		origin = character.global_position
		patrol_location_reached = true
		patrol_timer.start()
	else:
		patrol_timer.stop()
	
	current_state = state
	on_state_changed.emit(state)

func on_target_detection(body):
	if is_died(): return
	target = body
	wall_checker.target_position = target.global_position
	set_state(Constants.EnemyAIStates.ENGAGE)
	
func on_target_looking_detection(body):
	pass

func on_target_lost(body):
	if !is_died() and body == target:
		set_state(Constants.EnemyAIStates.PATROL)
		target = null
		
func is_died():
	return current_state == Constants.EnemyAIStates.DIE

func on_die():
	set_state(Constants.EnemyAIStates.DIE)

func _on_patrol_timer_timeout():
	if current_state != Constants.EnemyAIStates.PATROL: return
	var patrol_range = 50
	var random_x = randf_range(-patrol_range, patrol_range)
	var random_y = randf_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	patrol_move_direcrion = character.global_position.direction_to(patrol_location) * move_speed
