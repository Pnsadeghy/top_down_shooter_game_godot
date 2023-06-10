extends Node

class_name ShootSystem

@export var shoot_center: Marker2D
@export var bullet_scene: Resource
@export var bullet_flash: BulletFlash

@onready var cooldown_timer = $Cooldown

var allow_to_shoot = true

var type: Constants.CharacterType

func _ready():
	bullet_flash.visible = false
	bullet_flash.on_animation_end.connect(on_flash_end)
	
func set_type(character_type: Constants.CharacterType):
	type = character_type

func set_cooldown(cooldown: float):
	cooldown_timer.wait_time = cooldown

func shoot():
	if !allow_to_shoot: return false
	
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.global_position = shoot_center.global_position
	bullet.global_rotation = shoot_center.global_rotation
	
	match type:
		Constants.CharacterType.Player:
			bullet.add_to_group(Constants.PLAYER_BULLET_GROUP)
			bullet.modulate = Color.RED
			pass
		Constants.CharacterType.Enemy:
			bullet.add_to_group(Constants.ENEMY_BULLET_GROUP)
			pass
		Constants.CharacterType.Both:
			bullet.add_to_group(Constants.PLAYER_BULLET_GROUP)
			bullet.add_to_group(Constants.ENEMY_BULLET_GROUP)
			pass
	
	get_tree().root.add_child(bullet)
	
	allow_to_shoot = false
	cooldown_timer.start()
	
	bullet_flash.visible = true
	bullet_flash.show_flash()
	
	return true

func on_flash_end():
	bullet_flash.visible = false

func _on_cooldown_timeout():
	allow_to_shoot = true
