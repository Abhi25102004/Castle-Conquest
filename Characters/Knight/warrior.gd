extends Node2D

signal GiveDamageToGoblin
signal KnightDied

# constant 
enum States { Idle, Attack }

# variables
var Warrior : States = States.Idle
@export var health : int = randi_range(100,150)
@export var attack : int = randi_range(25,40)
@export var speed : float  = randf_range(1.5,2)
var canCharacterAttack : bool = false
var Game_State : bool = true
var CharacterName : String = "warrior"

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
			animations.play("Attack")
			await animations.animation_finished
			GiveDamageToGoblin.emit(10)
		
	Game_State = !Game_State
