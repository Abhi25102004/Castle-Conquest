extends Node

@onready var credit: Label = $Control/Credit
@onready var Animations: AnimationPlayer = $AnimationPlayer

func change_scene() -> void:
	MainMusic.stop()
	get_tree().change_scene_to_file("res://Main Game Scenes/start_scene.tscn")

func _ready() -> void:
	Global.Game_Starts = true
	Animations.play(Global.Difficulty)
	var Settings_File : Settings_Save = ResourceLoader.load("user://Settings_File.tres")
	match Global.Difficulty:
		"Easy":
			Settings_File.Game_Difficulty = "Medium"
		"Medium":
			Settings_File.Game_Difficulty = "Hard"
	ResourceSaver.save(Settings_File)
