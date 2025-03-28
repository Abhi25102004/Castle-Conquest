extends Node2D

class_name Knight_Class

signal KnightDied

# constant 
enum States { Idle, Attack, Death }

# variables
var Knight : States = States.Idle
var canAttack : bool = false
var Game_State : bool = true
var CharacterIsDead : bool = false
var Goblin_Array : Array[Goblin_Class] = []

var Health : float
var Attack : float
var Attack_Speed : float
var Cost : int

@export var Animated_node : AnimatedSprite2D
@export var HurtBox_node : Area2D

@onready var Animations: AnimatedSprite2D = Animated_node
@onready var HurtBox: Area2D = HurtBox_node

func HurtBox_Entered(_area: Area2D) -> void:
	pass

func HurtBox_Exited(_area: Area2D) -> void:
	pass

func OnAttack() -> void:
	pass

func Stats_Setter() -> void:
	pass

func Take_Damage_from_Goblin(Power : float) -> void:
	Health -= Power

func Game_Loop() -> void :
	canAttack = true if !Goblin_Array.is_empty() else false
	Knight = States.Death if Health <= 0 else Knight
	match Knight:
		States.Idle:
			Knight = States.Attack if canAttack else Knight
			Animations.play(Global.Theme_color + "_Idle")
		States.Attack:
			Knight = States.Idle
			if !Goblin_Array.is_empty():
				await get_tree().create_timer(Attack_Speed).timeout
				Animations.play(Global.Theme_color + "_Attack")
				await Animations.animation_finished
				OnAttack()
		States.Death:
			Animations.play("Death")
			await Animations.animation_finished
			KnightDied.emit()
			call_deferred("queue_free")
	Game_State = true

func _ready() -> void:
	Stats_Setter()
	HurtBox.area_entered.connect(HurtBox_Entered)
	HurtBox.area_exited.connect(HurtBox_Exited)

func _process(_delta: float) -> void:
	if Game_State:
		Game_State = false
		Game_Loop()
