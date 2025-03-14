extends Node2D

class_name Goblin_Class

signal GoblinDied

enum States { Idle, Run, Attack }

@export var Health : float
@export var Attack : float
@export var Attack_Speed : float
@export var Speed : float
@export var CharacterName : String
@export var Cost : int
@export var Direction : int = -1

var Goblin : States = States.Run
var Game_State : bool = true
var canAttack : bool = false
var Knight_Array : Array[Node2D] = []

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

func Take_Damage_from_knight(Power : float) -> void:
	Health -= Power
	if Health <= 0:
		Character_Death()

func Character_Death() -> void:
	GoblinDied.emit()
	Global.emit_signal("Add_Money",Cost)
	call_deferred("queue_free")

func Game_Loop(delta: float) -> void:
	canAttack = true if !Knight_Array.is_empty() else false
	match Goblin:
		States.Idle:
			Goblin = States.Attack if canAttack else States.Run
			Animations.play("Idle")
		States.Run:
			Goblin = States.Idle if canAttack else Goblin
			Animations.play("Run")
			position.x += Speed * delta * Direction
		States.Attack:
			Goblin = States.Idle
			await get_tree().create_timer(Attack_Speed).timeout
			Animations.play("Attack")
			await Animations.animation_finished
			OnAttack()
	Game_State = true

func _ready() -> void:
	Health *= Global.Difficulty
	Attack *= Global.Difficulty
	HurtBox.area_entered.connect(HurtBox_Entered)
	HurtBox.area_exited.connect(HurtBox_Exited)

func _process(delta: float) -> void:
	if Game_State:
		Game_State = false
		Game_Loop(delta)
