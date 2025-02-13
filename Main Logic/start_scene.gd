extends Node2D

func _ready() -> void:
	var directory = DirAccess.open("user://")
	if not directory.dir_exists("user://SaveFiles"):
		directory.make_dir_recursive("user://SaveFiles")
	else:
		if FileAccess.file_exists("user://SaveFiles/Level_Details.tres"):
			$Panel/VBoxContainer/Continue.visible = true

func Start_New_Game() -> void:
	var SaveFile: Level_Selection = Level_Selection.new()
	ResourceSaver.save(SaveFile, "user://SaveFiles/Level_Details.tres")
	Continue_Game()

func Game_Settings() -> void:
	pass

func Continue_Game() -> void:
	get_tree().change_scene_to_file("res://User Interface/level_interface.tscn")

func Quit_Game() -> void:
	get_tree().quit()
