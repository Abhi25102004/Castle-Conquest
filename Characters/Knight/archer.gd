extends Node2D

signal KnightDied

# constant 
enum States { Idle, Attack }

# variables
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker: Marker2D = $Marker2D

@export var health : int = randi_range(40,60)
@export var attack : int = randi_range(15,25)
@export var speed : float  = randf_range(1.0,1.3)
@export var Arrow_Scene : PackedScene

var Warrior : States = States.Idle
var Game_State : bool = true
var CharacterName : String = "warrior"
var canCharacterAttack : bool = false

func _process(_delta: float) -> void:
	if Game_State:
		Game_State = !Game_State
		Game_Loop()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	canCharacterAttack = true
	area.get_parent().GoblinDied.connect(Callable(self,"Enemy_Has_Died"))

func Take_Damage_from_Goblin(Power : int) -> void:
	health -= Power
	if health <= 0:
		KnightDied.emit()
		queue_free()

func Enemy_Has_Died() -> void:
	canCharacterAttack = false

func Add_arrow() -> void:
	var Arrow : Node2D = Arrow_Scene.instantiate()
	Arrow.position = marker.position
	Arrow.Attack = attack
	add_child(Arrow)

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
			Add_arrow()
		
	Game_State = !Game_State
