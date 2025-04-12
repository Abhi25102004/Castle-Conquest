extends Node2D
class_name Goblin_Class

# Signal emitted when goblin dies
signal GoblinDied

# Goblin behavior states
enum States { Idle, Run, Attack, Death }

# Core stats for the goblin
var Health : float
var Attack : float
var Attack_Speed : float
var Cost : float  # Coin reward on death
var Speed : float
var Direction : int = -1  # Moving from right to left

# Current state and control flags
var Goblin : States = States.Run
var Game_State : bool = true
var canAttack : bool = false
var Knight_Array : Array[Node2D] = []  # Knights in attack range

# Exported nodes (linked in editor)
@export var Animated_node : AnimatedSprite2D
@export var HurtBox_node : Area2D
@export var HitBox_CollisionShape_node : CollisionShape2D
@export var HurtBox_CollisionShape_node : CollisionShape2D

# Internal references to exported nodes
@onready var Animations: AnimatedSprite2D = Animated_node
@onready var HurtBox: Area2D = HurtBox_node
@onready var HitBox_CollisionShape: CollisionShape2D = HitBox_CollisionShape_node
@onready var HurtBox_CollisionShape: CollisionShape2D = HurtBox_CollisionShape_node

# Triggered when a knight enters the goblin’s range
func HurtBox_Entered(_area: Area2D) -> void:
	pass # Add knight to Knight_Array here

# Triggered when a knight exits the goblin’s range
func HurtBox_Exited(_area: Area2D) -> void:
	pass # Remove knight from Knight_Array here

# Called when goblin performs an attack
func OnAttack() -> void:
	pass # Damage logic for knights goes here

# Override this to define goblin-specific stats
func Stats_Setter() -> void:
	pass

# Called when goblin takes damage from a knight
func Take_Damage_from_knight(Power : float) -> void:
	Health -= Power

# Main state machine for the goblin
func Game_Loop(delta: float) -> void:
	canAttack = true if !Knight_Array.is_empty() else false

	# Death condition
	Goblin = States.Death if Health <= 0 else Goblin

	match Goblin:
		States.Idle:
			Animations.play("Idle")
			if canAttack:
				Goblin = States.Attack
			else:
				Goblin = States.Run

		States.Run:
			Animations.play("Run")
			position.x += Speed * delta * Direction
			if canAttack:
				Goblin = States.Idle

		States.Attack:
			await get_tree().create_timer(Attack_Speed).timeout
			if !Knight_Array.is_empty():
				Animations.play("Attack")
				await Animations.animation_finished
				OnAttack()
			Goblin = States.Idle

		States.Death:
			HitBox_CollisionShape.disabled = true
			Animations.flip_h = false
			Animations.play("Death")
			await Animations.animation_finished
			Global.Add_Money.emit(Cost)
			Global.Progress.emit()
			GoblinDied.emit()
			call_deferred("queue_free")

	Game_State = true

# Initialization
func _ready() -> void:
	Stats_Setter()
	HurtBox.area_entered.connect(HurtBox_Entered)
	HurtBox.area_exited.connect(HurtBox_Exited)

# Run the game loop each frame, but only once
func _process(delta: float) -> void:
	if Game_State:
		Game_State = false
		Game_Loop(delta)
