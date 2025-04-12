extends Node2D
class_name Knight_Class

# Signal emitted when the knight dies
signal KnightDied

# State machine for knight behavior
enum States { Idle, Attack, Death }

# Current state of the knight
var Knight : States = States.Idle
var canAttack : bool = false        # Whether the knight is allowed to attack
var Game_State : bool = true        # Used to trigger the Game_Loop once per frame
var CharacterIsDead : bool = false  # Flag to avoid repeated death handling
var Goblin_Array : Array[Goblin_Class] = []  # List of goblins in attack range

# Knight stats
var Health : float
var Attack : float
var Attack_Speed : float
var Cost : int
var Character_value : int

# Animation state string based on enum and global theme
var Animation_String : String:
	get = getAnimation_String

# Exported nodes from the scene
@export var Animated_node : AnimatedSprite2D
@export var HurtBox_node : Area2D
@export var HitBox_CollisionShape_node : CollisionShape2D

# Onready vars to use the exported nodes internally
@onready var Animations: AnimatedSprite2D = Animated_node
@onready var HurtBox: Area2D = HurtBox_node
@onready var HitBox_CollisionShape : CollisionShape2D = HitBox_CollisionShape_node

# Called when a goblin enters the knight's HurtBox (overlap area)
func HurtBox_Entered(_area: Area2D) -> void:
	pass # To be implemented: add goblin to Goblin_Array, etc.

# Called when a goblin exits the knight's HurtBox
func HurtBox_Exited(_area: Area2D) -> void:
	pass # To be implemented: remove goblin from Goblin_Array

# Called when the knight performs an attack
func OnAttack() -> void:
	pass # To be implemented: apply damage to goblin(s)

# Initializes the knight’s stats, should be overridden in derived class
func Stats_Setter() -> void:
	pass

# Applies damage to the knight
func Take_Damage_from_Goblin(Power : float) -> void:
	Health -= Power

# Dynamically returns the correct animation name based on current state and global theme
func getAnimation_String() -> String:
	match Knight:
		States.Idle:
			return Global.Theme_color + "_Idle"
		States.Attack:
			return Global.Theme_color + "_Attack"
		States.Death:
			return "Death"
	return ""

# Main game logic loop for the knight
func Game_Loop() -> void :
	# Can attack only if goblins are in range
	canAttack = true if !Goblin_Array.is_empty() else false

	# If health drops to 0, transition to Death state
	Knight = States.Death if Health <= 0 else Knight

	match Knight:
		States.Idle:
			Animations.play(Animation_String)
			if canAttack:
				Knight = States.Attack

		States.Attack:
			await get_tree().create_timer(Attack_Speed).timeout
			if !Goblin_Array.is_empty():
				Animations.play(Animation_String)
				await Animations.animation_finished
				OnAttack()
			Knight = States.Idle

		States.Death:
			# Disable hitbox to avoid further interactions
			HitBox_CollisionShape.disabled = true
			Animations.play(Animation_String)
			await Animations.animation_finished
			# Emit signal to notify others of death
			KnightDied.emit()
			call_deferred("queue_free") # Remove from scene safely

	# Reset game loop flag
	Game_State = true

# Initialization
func _ready() -> void:
	Stats_Setter()
	# Connect hurtbox signals to detect goblins
	HurtBox.area_entered.connect(HurtBox_Entered)
	HurtBox.area_exited.connect(HurtBox_Exited)

# Called every frame; runs Game_Loop once per frame
func _process(_delta: float) -> void:
	if Game_State:
		Game_State = false
		Game_Loop()
