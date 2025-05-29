extends Node

@warning_ignore("unused_signal")
signal Add_Money
@warning_ignore("unused_signal")
signal Remove_Money
@warning_ignore("unused_signal")
signal Progress
@warning_ignore("unused_signal")
signal SetUp

var Game_Starts : bool = true

var level_type : Level_Information = preload("res://Level Scenes and Data/Level Resources/Level_1.tres")

var Theme_color : String = "Blue"

var Difficulty : String = "Easy"

var Setting_Last_Scene : String = "res://Main Game Scenes/start_scene.tscn"

var Endless : bool = false

var Screen : String = ""

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Screen Size"):
		match Global.Screen:
			"FullScreen":
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
				Global.Screen = "Maximized"
			"Maximized":
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				Global.Screen = "FullScreen"
		var Settings : Settings_Save = ResourceLoader.load("user://Settings_File.tres")
		Settings.Scree_Size = Global.Screen
		ResourceSaver.save(Settings,"user://Settings_File.tres")
