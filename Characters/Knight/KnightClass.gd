extends Node2D

class_name Knight_Class

signal KnightDied

enum States { Idle, Attack, Death }

var Knight : States = States.Idle
var canAttack : bool = false
var Game_State : bool = true
var CharacterIsDead : bool = false
var Goblin_Array : Array[Goblin_Class] = []

var Health : float
var Attack : float
var Attack_Speed : float
var Cost : int
var Points : int

var Animation_String : String:
	get = getAnimation_String

@export var Animated_node : AnimationPlayer
@export var HurtBox_node : Area2D
@export var HitBox_CollisionShape_node : CollisionShape2D

@onready var Animations: AnimationPlayer = Animated_node
@onready var HurtBox: Area2D = HurtBox_node
@onready var HitBox_CollisionShape : CollisionShape2D = HitBox_CollisionShape_node

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

func getAnimation_String() -> String:
	match Knight:
		States.Idle:
			return Global.Theme_color + "_Idle"
		States.Attack:
			return Global.Theme_color + "_Attack"
		States.Death:
			return "Death"
	return ""

func Game_Loop() -> void :
	canAttack = true if !Goblin_Array.is_empty() else false

	Knight = States.Death if Health <= 0 else Knight

	match Knight:
		States.Idle:
			Animations.play(Animation_String)
			if canAttack:
				Knight = States.Attack

		States.Attack:
			await get_tree().create_timer(Attack_Speed).timeout
			if !Goblin_Array.is_empty() and Health > 0:
				Animations.play(Animation_String)
				await Animations.animation_finished
				OnAttack()
			Knight = States.Idle

		States.Death:
			HitBox_CollisionShape.set_deferred("disable",true)
			Animations.play(Animation_String)
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
