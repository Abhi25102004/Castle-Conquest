extends Node2D

class_name Knight_Class

signal KnightDied

# constant 
enum States { Idle, Attack }

# variables
var Knight : States = States.Idle
var canAttack : bool = false
var Game_State : bool = true

var CharacterName : String
@export var Health : int
@export var Attack : int
@export var Attack_Speed : float

@export var Animated_node : AnimatedSprite2D
@export var HurtBox_node : Area2D

# nodes and scenes
@onready var Animations: AnimatedSprite2D = Animated_node
@onready var HurtBox: Area2D = HurtBox_node

func Setter() -> void:
	pass

func HurtBox_Entered(_area: Area2D) -> void:
	pass

func HurtBox_Exited(_area: Area2D) -> void:
	pass

func OnAttack() -> void:
	pass

func Take_Damage_from_Goblin(Power : int) -> void:
	Health -= Power
	if Health <= 0:
		Character_Death()

func Character_Death() -> void:
	KnightDied.emit()
	Game_State = false
	queue_free()

func Game_Loop() -> void :
	match Knight:
		States.Idle:
			Knight = States.Attack if canAttack else Knight
			Animations.play("Idle")
		States.Attack:
			Knight = States.Idle
			await get_tree().create_timer(Attack_Speed).timeout
			Animations.play("Attack")
			await Animations.animation_finished
			OnAttack()
	Game_State = true

func _ready() -> void:
	Setter()
	HurtBox.area_entered.connect(HurtBox_Entered)
	HurtBox.area_exited.connect(HurtBox_Exited)

func _process(_delta: float) -> void:
	if Game_State:
		Game_State = false
		Game_Loop()
