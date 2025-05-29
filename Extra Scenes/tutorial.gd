extends Node

@onready var Animations: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $"Main Label/ColorRect"
@onready var skip_button: Button = $"Main Label/Skip button"

func Change_Scene() -> void:
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Main Game Scenes/level_interface.tscn")

func End_Tutorial() -> void:
	Animations.play()
	await Animations.animation_finished
	call_deferred("Change_Scene")

func _ready() -> void:
	skip_button.pressed.connect(func():
		skip_button.disabled = true
		Animations.play("Ending")
		await Animations.animation_finished
		call_deferred("Change_Scene")
		)
