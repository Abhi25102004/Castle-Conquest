extends Node2D

signal KnightDied

# constant 
enum States { Idle, Attack }

# variables
var Knight : States = States.Idle
var gettingAttacked : bool = false
var Game_State : bool = true

var Health : float = randf_range(299,301)
var Cost : int = 60

@onready var Animations: AnimatedSprite2D = $AnimatedSprite2D

func Take_Damage_from_Goblin(Power : int) -> void:
	Health -= Power
	gettingAttacked = true
	if Health <= 0:
		Character_Death()

func Character_Death() -> void:
	KnightDied.emit()
	queue_free()

func Game_Loop() -> void :
	match Knight:
		States.Idle:
			Knight = States.Attack if gettingAttacked else Knight
			Animations.play("Idle")
		States.Attack:
			Knight = States.Idle
			Animations.play("Attack")
			await Animations.animation_finished
			gettingAttacked = false
	Game_State = true

func _process(_delta: float) -> void:
	if Game_State:
		Game_State = false
		Game_Loop()
