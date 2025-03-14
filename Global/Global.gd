extends Node

# Global Signals
@warning_ignore("unused_signal")
signal Add_Money
@warning_ignore("unused_signal")
signal Update_Wave

# Global variables
var level_type : Level_Information = preload("res://Level_Resourse/Level_1.tres")
var Buttons : Array[String] = ["Pawn"]
var Theme_color : String = "Blue"
var Difficulty : float = 1
var Setting_Last_Scene : String = "res://Main Logic/start_scene.tscn"
