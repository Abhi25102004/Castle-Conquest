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
