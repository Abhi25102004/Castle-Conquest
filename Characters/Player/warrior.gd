extends Node2D

signal GiveDamageToEnemy

# constant 
const MaxHealth : int = 100
enum States { Idle, Attack }
enum AttackType { Emit , Normal }

# variables
var Warrior : States = States.Idle
var WarrorAttackType : AttackType = AttackType.Emit
var health : int = MaxHealth
var EnemyArray : Array = []
var waitTime : float = 0.6

# nodes and scenes
@onready var animations: AnimatedSprite2D = $Animations
@export var Attack_wave : PackedScene 
@onready var marker_2d: Marker2D = $Marker2D

func _process(delta: float) -> void:
	match Warrior:
		States.Idle:
			animations.play("Idle")
			await animations.animation_finished
			Warrior = States.Attack if EnemyArray.size() else States.Idle
			
		States.Attack:
				animations.play("Attack")
				await animations.animation_finished
				Warrior = States.Idle
				waitTime -= delta
				if waitTime <= 0:
					match WarrorAttackType:
						AttackType.Emit:
							var attack : Node2D = Attack_wave.instantiate()
							attack.global_position = marker_2d.global_position
							get_parent().add_child(attack)
						AttackType.Normal:
							GiveDamageToEnemy.emit(9)
					waitTime = 0.6

func _on_hurt_box_area_entered(area: Area2D) -> void:
	EnemyArray.append(area.get_parent())

func TakeDamage(Power : int) -> void:
	health -= Power
	if health <= 0:
		queue_free()

func _on_hit_box_area_entered(area: Area2D) -> void:
	WarrorAttackType = AttackType.Normal
	var Torch : Node2D = area.get_parent()
	if Torch.name == "Torch":
		connect("GiveDamageToEnemy",Callable(Torch,"TakeDamage"))

func _on_hit_box_area_exited(area: Area2D) -> void:
	Warrior = States.Idle
	var Torch : Node2D = area.get_parent()
	if Torch.name == "Torch":
		disconnect("GiveDamageToEnemy",Callable(Torch,"TakeDamage"))

func CheckIfDead(NodeToRemove : Node2D):
	NodeToRemove.disconnect("IfDead",CheckIfDead)
	EnemyArray.remove_at(EnemyArray.find(NodeToRemove))
