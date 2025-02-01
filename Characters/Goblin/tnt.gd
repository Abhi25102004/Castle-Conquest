extends Node2D

signal GoblinDied

const MaxHealth : int = 100
var Speed : int = randi_range(60,90)
enum States { Idle, Run, Attack }

var Torch : States = States.Run

@export var health : int = randi_range(80,120)
@export var attack : int = randi_range(30,50)
@export var speed : float  = randf_range(1.5,2.0)

var Game_State : bool = true
var CharacterName : String = "torch"
@export var Dynamite : PackedScene

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker: Marker2D = $Marker2D

func _process(delta: float) -> void:
	if Game_State:
		Game_State = !Game_State
		Game_Loop(delta)

func _on_hurt_box_area_entered(_area: Area2D) -> void:
	Torch = States.Idle

func _on_hurt_box_area_exited(_area: Area2D) -> void:
	Torch = States.Run

func Take_Damage_from_knight(Power : int) -> void:
	health -= Power
	if health <= 0:
		GoblinDied.emit()
		queue_free()

func Add_Dynamite() -> void:
	var Dynamite_instance : Node2D = Dynamite.instantiate()
	Dynamite_instance.Attack = attack
	Dynamite_instance.position = marker.position
	add_child(Dynamite_instance)

func Game_Loop(delta: float) -> void:
	
	match Torch:
		
		States.Idle:
			Torch = States.Attack
			animations.play("Idle")
		
		States.Run:
			animations.play("Run")
			position.x -= Speed * delta
			
		States.Attack:
			Torch = States.Idle
			await get_tree().create_timer(speed).timeout
			animations.play("Attack")
			await animations.animation_finished
			Add_Dynamite()
	
	Game_State = !Game_State
