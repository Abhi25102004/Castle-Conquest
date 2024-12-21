extends Node2D

signal GiveDamage
signal IfDead

const MaxHealth : int = 100
const Speed : int = 65
enum States { Idle, Run, Attack }

var Warrior : States = States.Run
var health : int = MaxHealth
var waitTime : float = 0.6
var Power : int = randi_range(5,10)

@onready var animations: AnimatedSprite2D = $Animations

func _ready() -> void:
	add_to_group("1st Row")

func _process(delta: float) -> void:
	match Warrior:
		States.Idle:
			animations.play("Idle")
			await animations.animation_finished
			Warrior = States.Attack
		
		States.Run:
			animations.play("Run")
			position.x -= Speed * delta
			
		States.Attack:
			animations.play("Attack")
			await animations.animation_finished
			Warrior = States.Idle
			waitTime -= delta
			if waitTime <= 0:
				GiveDamage.emit(Power)
				waitTime = 0.6

func HurtBoxEntered(area: Area2D) -> void:
	Warrior = States.Attack
	var WarriorNode : Node2D = area.get_parent()
	connect("GiveDamage",Callable(WarriorNode,"TakeDamage"))

func HurtBoxExited(area: Area2D) -> void:
	Warrior = States.Run
	var WarriorNode : Node2D = area.get_parent()
	disconnect("GiveDamage",Callable(WarriorNode,"TakeDamage"))

func HitBoxEntered(area: Area2D) -> void:
	var NodeName : Node2D = area.get_parent()
	match NodeName.name:
		"Attack Wave":
			TakeDamage(NodeName.Power)
		"Warrior":
			connect("IfDead",Callable(NodeName,"CheckIfDead"))

func TakeDamage(Power : int) -> void:
	health -= Power
	if health <= 0:
		IfDead.emit($".")
		queue_free()
