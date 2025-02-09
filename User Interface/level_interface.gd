extends Control

@onready var LevelsGrid: GridContainer = $PanelContainer/MarginContainer/VBoxContainer/GridContainer
@export var LevelValue : Dictionary

func Change_Scene(child : Button) -> void:
	if int(child.text) > 0:
		var Level_S : Level_Selection = Level_Selection.new()
		Level_S.level = LevelValue[int(child.text)]
		ResourceSaver.save(Level_S,"res://Level_Resourse/Level_select.tres")
		get_tree().change_scene_to_file("res://Test Scenes/test_world.tscn")

func _ready() -> void:
	for iter in LevelValue.keys():
		var levelButton : Button = preload("res://User Interface/Level_Button.tscn").instantiate()
		if iter == 1:
			levelButton.text = "Level " + str(iter) + " : " + LevelValue[iter].Level_Name
		elif LevelValue[iter-1].Completed:
			levelButton.text = "Level " + str(iter) + " : " + LevelValue[iter].Level_Name
		else:
			levelButton.icon = preload("res://Assets/UI/Icons/Regular_10.png")
		LevelsGrid.add_child(levelButton)
		levelButton.pressed.connect(Change_Scene.bind(levelButton))
