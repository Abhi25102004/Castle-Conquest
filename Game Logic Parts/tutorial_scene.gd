extends Node

@onready var Animations: AnimationPlayer = $AnimationPlayer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("MouseClick"):
		Animations.play("Start")
