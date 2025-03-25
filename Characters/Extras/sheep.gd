extends Node2D

signal KnightDied

# constant 
enum States { Idle, Attack }

# variables
var Knight : States = States.Idle
var getingAttacked : bool = false
var Game_State : bool = true
var Enemy : Goblin_Class = null

@export var CharacterName : String
@export var Health : int
@export var Cost : int

@onready var Animations: AnimatedSprite2D = $AnimatedSprite2D

func Take_Damage_from_Goblin(Power : int) -> void:
	Health -= Power
	getingAttacked = true
	if Health <= 0:
		Character_Death()

func Character_Death() -> void:
	KnightDied.emit()
	Enemy.Health = Enemy.Health/2
	Enemy.Speed = Enemy.Speed/2
	Enemy.Attack = Enemy.Attack/2
	call_deferred("queue_free")

func Game_Loop() -> void :
	match Knight:
		States.Idle:
			Knight = States.Attack if getingAttacked else Knight
			Animations.play("Idle")
		States.Attack:
			Knight = States.Idle
			Animations.play("Attack")
			await Animations.animation_finished
			getingAttacked = false
	Game_State = true

func _process(_delta: float) -> void:
	if Game_State:
		Game_State = false
		Game_Loop()

func Enemy_Entered(area: Area2D) -> void:
	if area.get_parent() is Goblin_Class:
		Enemy = area.get_parent()

func Enemy_Exited(area: Area2D) -> void:
	if area.get_parent() is Goblin_Class:
		Enemy = null
