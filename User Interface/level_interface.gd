extends Control

@onready var Level_Grid: GridContainer = $PanelContainer/MarginContainer/VBoxContainer/GridContainer
@export var Level_Value : Dictionary
var Level_Completed : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")

func On_Button_Pressed(number: int) -> void:
	var level_info : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")
	level_info.Current_Level = number
	ResourceSaver.save(level_info,"user://SaveFiles/Level_Details.tres")
	get_tree().change_scene_to_file("res://Test Scenes/test_world.tscn")

func _ready() -> void:
	for iter in range(1,11):
		var levelButton : Button = preload("res://User Interface/Level_Button.tscn").instantiate()
		if iter == 1 or iter-1 in Level_Completed.level_Played:
			levelButton.text = Level_Value[iter].Level_Name
			levelButton.pressed.connect(On_Button_Pressed.bind(iter))
		else:
			levelButton.icon = preload("res://Assets/UI/Icons/Regular_10.png")
		Level_Grid.add_child(levelButton)

func Quit_Button() -> void:
	get_tree().change_scene_to_file("res://Main Logic/start_scene.tscn")
