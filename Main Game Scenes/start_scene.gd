extends CanvasLayer

@onready var Animations: AnimationPlayer = $AnimationPlayer
@onready var continue_button: Button = $Panel/MarginContainer/VBoxContainer/VBoxContainer/Continue

func _ready() -> void:
	var directory = DirAccess.open("user://")
	if not directory.dir_exists("user://SaveFiles"):
		directory.make_dir_recursive("user://SaveFiles")
	else:
		if FileAccess.file_exists("user://SaveFiles/Level_Details.tres"):
			continue_button.visible = true
		else:
			continue_button.visible = false

func Save_file() -> void:
	var SaveFile : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")
	Global.Theme_color = SaveFile.Color_String
	Global.Difficulty = SaveFile.Game_Difficulty
	Animations.play("transition")
	await Animations.animation_finished

func Start_New_Game() -> void:
	var SaveFile: Level_Selection = Level_Selection.new()
	ResourceSaver.save(SaveFile, "user://SaveFiles/Level_Details.tres")
	await Save_file()
	get_tree().change_scene_to_file("res://Main Game Scenes/tutorial_scene.tscn")

func Game_Settings() -> void:
	Animations.play("transition")
	await Animations.animation_finished
	Global.Setting_Last_Scene = "res://Main Game Scenes/start_scene.tscn"
	get_tree().change_scene_to_file("res://Main Game Scenes/settings_scene.tscn")

func Continue_Game() -> void:
	await Save_file()
	get_tree().change_scene_to_file("res://Main Game Scenes/level_interface.tscn")

func Quit_Game() -> void:
	get_tree().quit()
