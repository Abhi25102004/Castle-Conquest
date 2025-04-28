extends Node

@onready var credit: Label = $Control/Credit
@onready var Animations: AnimationPlayer = $AnimationPlayer

func change_scene() -> void:
	get_tree().change_scene_to_file("res://Main Game Scenes/start_scene.tscn")

func _ready() -> void:
	Global.Game_Starts = true
	Animations.play(Global.Difficulty)
	var SaveFile : Level_Selection = ResourceLoader.load("user://Level_Details.tres")
	match Global.Difficulty:
		"Easy":
			SaveFile.Game_Difficulty = "Medium"
		"Medium":
			SaveFile.Game_Difficulty = "Hard"
	ResourceSaver.save(SaveFile)
