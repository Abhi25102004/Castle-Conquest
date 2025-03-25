extends Node2D

var Attack : int
var speed : int = 700
var wait_time : float = 5
var Direction : Vector2 = Vector2(1,0)

func _process(delta: float) -> void:
	position += Direction * speed * delta
	wait_time -= delta
	if wait_time <= 0:
		call_deferred("queue_free")

func Remove_Arrow(area: Area2D) -> void:
	if area.get_parent().has_method("Take_Damage_from_knight"):
		area.get_parent().Take_Damage_from_knight(Attack)
	call_deferred("queue_free")
