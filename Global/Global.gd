extends Node

@warning_ignore("unused_signal")
signal Add_Money
@warning_ignore("unused_signal")
signal Remove_Money
@warning_ignore("unused_signal")
signal Progress
@warning_ignore("unused_signal")
signal SetUp


var level_type : Level_Information = preload("res://Level_Resourse/Level_1.tres")

var Level_Name : String = ""

var Buttons : Array[String] = ["Pawn"]

var Theme_color : String = "Blue"

var Difficulty : String = "Easy"

var Setting_Last_Scene : String = "res://Main Logic/start_scene.tscn"
