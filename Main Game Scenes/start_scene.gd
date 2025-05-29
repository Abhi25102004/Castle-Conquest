extends CanvasLayer

@onready var Animations: AnimationPlayer = $AnimationPlayer
@onready var continue_button: Button = $Panel/MarginContainer/VBoxContainer/Continue
@onready var new_game: Button = $"Panel/MarginContainer/VBoxContainer/New Game"
@onready var settings: Button = $Panel/MarginContainer/VBoxContainer/Settings
@onready var quit: Button = $Panel/MarginContainer/VBoxContainer/Quit

@export var Tutorial_level : Level_Information

func _ready() -> void:
	if FileAccess.file_exists("user://Settings_File.tres"):
		Save_file()
		var Settings : Settings_Save = ResourceLoader.load("user://Settings_File.tres")
		if Settings.continue_available:
			continue_button.visible = true
		else:
			continue_button.visible = false
	else:
		ResourceSaver.save(SaveFile.new(), "user://Save_File.tres")
		ResourceSaver.save(Settings_Save.new(), "user://Settings_File.tres")
		ResourceSaver.save(Achievement_Save.new(), "user://Achievement_File.tres")
		
	if Global.Game_Starts:
		Animations.play("Start")
		Global.Game_Starts = false
	else:
		Animations.play("Normal Entry")
		
	await Animations.animation_finished
	
func Save_file() -> void:
	var Saved_settings_file : Settings_Save = ResourceLoader.load("user://Settings_File.tres")
	Global.Theme_color = Saved_settings_file.Player_Colour
	Global.Difficulty = Saved_settings_file.Game_Mode
	for Bus_name in Saved_settings_file.Sound_Controller:
		var Bus_index : int = AudioServer.get_bus_index(Bus_name)
		AudioServer.set_bus_volume_db(Bus_index,linear_to_db(Saved_settings_file.Sound_Controller[Bus_name]))
	
func Start_New_Game() -> void:
	new_game.disabled = true
	var Settings : Settings_Save = ResourceLoader.load("user://Settings_File.tres")
	if !Settings.continue_available:
		Settings.continue_available = true
		ResourceSaver.save(Settings,"user://Settings_File.tres")
	ResourceSaver.save(SaveFile.new(), "user://Save_File.tres")
	Save_file()
	Animations.play("transition")
	Global.level_type = Tutorial_level
	await Animations.animation_finished
	call_deferred("Change_Scene", "res://Extra Scenes/tutorial.tscn")

func Game_Settings() -> void:
	settings.disabled = true
	Global.Setting_Last_Scene = "res://Main Game Scenes/start_scene.tscn"
	Animations.play("transition")
	await Animations.animation_finished
	call_deferred("Change_Scene", "res://Main Game Scenes/settings_scene.tscn")

func Continue_Game() -> void:
	continue_button.disabled = true
	Animations.play("transition")
	await Animations.animation_finished
	call_deferred("Change_Scene", "res://Main Game Scenes/level_interface.tscn")

func Quit_Game() -> void:
	quit.disabled = true
	get_tree().quit()

func Change_Scene(Change_file: String) -> void:
	if is_inside_tree():
		get_tree().change_scene_to_file(Change_file)

func Play_Song() -> void:
	MainMusic.play()
