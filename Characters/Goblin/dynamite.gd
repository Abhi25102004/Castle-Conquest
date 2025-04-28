extends Node2D

var Attack : int
var Vertical_speed : int = 550
var Rotation_speed : int = 10
var wait_time : float = 5

@onready var Animations: AnimationPlayer = $AnimationPlayer


func _process(delta: float) -> void:
	position += Vector2(-1,0) * Vertical_speed * delta
	rotation += Rotation_speed * delta
	wait_time -= delta
	if wait_time <= 0:
		call_deferred("queue_free")

func Remove_Arrow(area: Area2D) -> void:
	if area.get_parent().has_method("Take_Damage_from_Goblin"):
		Vertical_speed = 0
		Rotation_speed = 0
		area.get_parent().Take_Damage_from_Goblin(Attack)
		Animations.play("Blast")
		await Animations.animation_finished
		call_deferred("queue_free")
