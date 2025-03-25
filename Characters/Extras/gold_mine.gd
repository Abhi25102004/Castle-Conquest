extends Node2D

signal KnightDied

# constant 
enum States { Idle, Attack }

# variables
var Knight : States = States.Idle
var canAttack : bool = false
var Game_State : bool = true
var CharacterIsDead : bool = false
var Goblin_Array : Array[Goblin_Class] = []

@export var CharacterName : String
@export var Health : float
@export var Cost : float

@onready var Images: Sprite2D = $Sprite2D

func Take_Damage_from_Goblin(Power : float) -> void:
	Health -= Power
	if Health <= 0:
		Character_Death()

func Character_Death() -> void:
	KnightDied.emit()
	call_deferred("queue_free")

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	Global.Add_Money.emit(200)
	Images.texture = preload("res://Assets/Resources/Gold Mine/GoldMine_Inactive.png")
