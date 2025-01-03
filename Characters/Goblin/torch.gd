extends Node2D

signal GiveDamageToKnight
signal GoblinDied

const MaxHealth : int = 100
var Speed : int = randi_range(80,120)
enum States { Idle, Run, Attack }

var Torch : States = States.Run

@export var health : int = randi_range(50,80)
@export var attack : int = randi_range(15,25)
@export var speed : float  = randf_range(1.2,1.5)

var Game_State : bool = true
var CharacterName : String = "torch"

@onready var animations: AnimatedSprite2D = $Animations

func _process(delta: float) -> void:
	if Game_State:
		Game_State = !Game_State
		Game_Loop(delta)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	Torch = States.Idle
	GiveDamageToKnight.connect(Callable(area.get_parent(),"Take_Damage_from_Goblin"))

func _on_hurt_box_area_exited(area: Area2D) -> void:
	Torch = States.Run
	GiveDamageToKnight.disconnect(Callable(area.get_parent(),"Take_Damage_from_Goblin"))

func Take_Damage_from_knight(Power : int) -> void:
	health -= Power
	if health <= 0:
		GoblinDied.emit()
		queue_free()

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
			GiveDamageToKnight.emit(attack)
	
	Game_State = !Game_State
