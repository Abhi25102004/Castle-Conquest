extends Node2D

signal KnightDied

# constant 
enum States { Idle, Attack }

# variables
var Knight : States = States.Idle
var canAttack : bool = false
var Game_State : bool = true
var Goblin_Array : Array[Goblin_Class] = []
var Arrow_Scene : PackedScene = preload("res://Characters/Knight/arrow.tscn")

@export var Image_Dict : Dictionary

var Health : float = randf_range(149,151)
var Attack : float = randf_range(29,31)
var Attack_Speed : float = randf_range(0.7,0.9)
var Cost : int = 150

@export var HurtBox_node : Area2D

@onready var Picture: Sprite2D = $Sprite2D
@onready var HurtBox: Area2D = HurtBox_node
@onready var marker: Marker2D = $Marker2D
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

func HurtBox_Entered(area: Area2D) -> void:
	Goblin_Array.append(area.get_parent())

func HurtBox_Exited(area: Area2D) -> void:
	Goblin_Array.erase(area.get_parent())

func OnAttack() -> void:
	if !Goblin_Array.is_empty():
		var Goblin : Goblin_Class = Goblin_Array[0]
		var Arrow : Node2D = Arrow_Scene.instantiate()
		Arrow.position = marker.position
		Arrow.Attack = Attack
		Arrow.rotation = marker.global_position.angle_to_point(Goblin.global_position)
		Arrow.Direction = (Goblin.global_position - marker.global_position).normalized()
		Arrow.speed = 700
		call_deferred("add_child",Arrow)

func Take_Damage_from_Goblin(Power : int) -> void:
	Health -= Power
	if Health <= 0:
		Character_Death()

func Character_Death() -> void:
	KnightDied.emit()
	call_deferred("queue_free")

func Game_Loop() -> void :
	canAttack = true if !Goblin_Array.is_empty() else false
	match Knight:
		States.Idle:
			Knight = States.Attack if canAttack else Knight
			animations.play("Idle")
		States.Attack:
			Knight = States.Idle
			await get_tree().create_timer(Attack_Speed).timeout
			animations.play("Attack")
			await animations.animation_finished
			OnAttack()
	Game_State = true

func _ready() -> void:
	Picture.texture = Image_Dict.get(Global.Theme_color)
	HurtBox.area_entered.connect(HurtBox_Entered)
	HurtBox.area_exited.connect(HurtBox_Exited)

func _process(_delta: float) -> void:
	if Game_State:
		Game_State = false
		Game_Loop()
