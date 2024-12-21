extends Node2D

@export var Power : int = randi_range(5,10)

func _process(delta: float) -> void:
	position += 200 * delta * Vector2(1,0)

func EnemyHitBoxEntered(area: Area2D) -> void:
	queue_free()
