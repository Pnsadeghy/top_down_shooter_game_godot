extends Node2D

class_name Weapon



@export var type: Constants.CharacterType
@export var cooldown := 1
@export var max_ammo := 5

@onready var shoot_system: ShootSystem = $ShootSystem
var current_ammo := max_ammo

func _ready():
	shoot_system.set_type(type)
	shoot_system.set_cooldown(cooldown)

func can_shoot():
	return shoot_system.allow_to_shoot

func shoot():
	shoot_system.shoot()
	current_ammo -= 1
