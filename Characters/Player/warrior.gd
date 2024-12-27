extends Node2D

signal GiveDamageToGoblin
signal KnightDied

# constant 
enum States { Idle, Attack }

# variables
var Warrior : States = States.Idle
@export var health : int
@export var attack : int 
@export var speed : float  
var canCharacterAttack : bool = false
var Game_State : bool = true

# nodes and scenes
@onready var animations: AnimatedSprite2D = $Animations

func _process(_delta: float) -> void:
	if Game_State:
		Game_State = !Game_State
		Game_Loop()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	canCharacterAttack = true
	GiveDamageToGoblin.connect(Callable(area.get_parent(),"Take_Damage_from_knight"))

func _on_hurt_box_area_exited(area: Area2D) -> void:
	canCharacterAttack = false
	GiveDamageToGoblin.disconnect(Callable(area.get_parent(),"Take_Damage_from_knight"))

func Take_Damage_from_Goblin(Power : int) -> void:
	health -= Power
	if health <= 0:
		KnightDied.emit()
		queue_free()

func Game_Loop() -> void :
	
	match Warrior:
		
		States.Idle:
			Warrior = States.Attack if canCharacterAttack else Warrior
			animations.play("Idle")
		
		States.Attack:
			Warrior = States.Idle
			await get_tree().create_timer(speed).timeout
			animations.play("Attack" if randf() > 0.5 else "Attack_2")
			await animations.animation_finished
			print_debug("Do damage to Goblin")
			GiveDamageToGoblin.emit(10)
		
	Game_State = !Game_State
