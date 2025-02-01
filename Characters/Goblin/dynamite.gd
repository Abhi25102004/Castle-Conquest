extends Node2D

var Attack : int
var speed : int = 500
var wait_time : float = 5

func _process(delta: float) -> void:
	position += Vector2(-1,0) * speed * delta
	wait_time -= delta
	if wait_time <= 0:
		queue_free()

func Remove_Arrow(area: Area2D) -> void:
	if area.get_parent().has_method("Take_Damage_from_Goblin"):
		area.get_parent().Take_Damage_from_Goblin(Attack)
	queue_free()
