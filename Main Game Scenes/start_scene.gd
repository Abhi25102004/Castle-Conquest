extends CanvasLayer

@onready var Animations: AnimationPlayer = $AnimationPlayer
@onready var continue_button: Button = $Panel/MarginContainer/VBoxContainer/Continue

func _ready() -> void:
	if FileAccess.file_exists("user://Level_Details.tres"):
		Save_file()
		continue_button.visible = true
	else:
		var SaveFile: Level_Selection = Level_Selection.new()
		ResourceSaver.save(SaveFile, "user://Level_Details.tres")
		Save_file()
		continue_button.visible = false
	
	if Global.Game_Starts:
		Animations.play("Start")
		Global.Game_Starts = false
	else:
		Animations.play("Normal Entry")
	await Animations.animation_finished
	
func Save_file() -> void:
	var SaveFile : Level_Selection = ResourceLoader.load("user://Level_Details.tres")
	Global.Theme_color = SaveFile.Color_String
	Global.Difficulty = SaveFile.Game_Difficulty
	Global.Buttons = SaveFile.Available_Buttons
	for Bus_name in SaveFile.Audio:
		var Bus_index : int = AudioServer.get_bus_index(Bus_name)
		AudioServer.set_bus_volume_db(Bus_index,linear_to_db(SaveFile.Audio[Bus_name]))
	
func Start_New_Game() -> void:
	Animations.play("transition")
	await Animations.animation_finished
	call_deferred("Change_Scene", "res://Main Game Scenes/tutorial_scene.tscn")

func Game_Settings() -> void:
	Global.Setting_Last_Scene = "res://Main Game Scenes/start_scene.tscn"
	Animations.play("transition")
	await Animations.animation_finished
	call_deferred("Change_Scene", "res://Main Game Scenes/settings_scene.tscn")

func Continue_Game() -> void:
	Animations.play("transition")
	await Animations.animation_finished
	call_deferred("Change_Scene", "res://Main Game Scenes/level_interface.tscn")

func Quit_Game() -> void:
	get_tree().quit()

func Change_Scene(Change_file: String) -> void:
	if not is_inside_tree():
		return
	get_tree().change_scene_to_file(Change_file)

func Play_Song() -> void:
	MainMusic.play()
