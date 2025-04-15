extends PanelContainer

@onready var achievement_name: Label = $VBoxContainer/Achievement_name
@onready var achievement_description: Label = $VBoxContainer/Achievement_description
@onready var completed: Label = $Completed

@export var Number : int
@export var Name : String
@export var Description : String

func _ready() -> void:
	completed.visible = false
	achievement_name.text = Name
	achievement_description.text = Description
	
	var SaveFile : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")
	
	match Number:
		1:
			if 1 in SaveFile.level_Played:
				completed.visible = true
		2:
			if 5 in SaveFile.level_Played:
				completed.visible = true
		3:
			if SaveFile.Difficulty_played["Easy"].size() == 10:
				completed.visible = true
		4:
			if SaveFile.Difficulty_played["Medium"].size() == 10:
				completed.visible = true
		5:
			if SaveFile.Difficulty_played["Hard"].size() == 10:
				completed.visible = true
