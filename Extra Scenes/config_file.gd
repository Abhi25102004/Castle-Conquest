extends Node2D

func _ready() -> void:
	var Save_File : SaveFile = ResourceLoader.load("user://Save_File.tres")
	Save_File.Endless_High_Score = 5
	Save_File.Difficulty_played["Hard"] = [1,2,3,4,5,6,7]
	Save_File.Difficulty_played["Medium"] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
	Save_File.Difficulty_played["Easy"] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
	ResourceSaver.save(Save_File,"user://Save_File.tres")
	get_tree().quit()
