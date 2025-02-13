extends CanvasLayer

@onready var Placement_Buttons: GridContainer = $PanelContainer/MarginContainer/VBoxContainer/Middle/GridContainer
@onready var Character_Buttons: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Bottom/HBoxContainer
@onready var Money_Counter: Label = $PanelContainer/MarginContainer/VBoxContainer/Header/Label
@onready var progress_bar: ProgressBar = $"PanelContainer/MarginContainer/VBoxContainer/Header/Progress Level/HBoxContainer2/ProgressBar"

var Level_Completed : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")
var cost : int = 0
var Character_Scene : PackedScene = null
var Money : int = 0

func Placement_Button_Pressed(child : Button) -> void:
	if !child.placed and Money >= cost:
		if Character_Scene and child.has_method("Add_Scene"):
			child.Scene = Character_Scene
			child.placed = true
			child.Add_Scene()
			Money = (Money - cost) if (Money - cost) >= 0 else 0
			Money_Counter.text = "Money : " + str(Money) 
			Character_Scene = null
			cost = 0
	else:
		child.placed = false
		child.Remove_Scene()
		

func Add_Character(child : Button) -> void:
	Character_Scene = child.Scene
	cost = child.value

func Increase_Money() -> void:
	Money += randi_range(50,100)
	Money_Counter.text = "Money : " + str(Money) 

func Progress_Bar_Setter(number: int) -> void:
	progress_bar.min_value = 0
	progress_bar.max_value = number

func Progress_Bar_Update(number: int) -> void:
	progress_bar.value = number

func _ready() -> void:
	for child in Placement_Buttons.get_children():
		if child is Button:
			child.pressed.connect(Placement_Button_Pressed.bind(child))
	
	for child in Character_Buttons.get_children():
		if child is Button and child.name in Level_Completed.Available_Buttons:
			child.visible = true
		child.pressed.connect(Add_Character.bind(child))
	
	%"Quite Button".pressed.connect(func(): get_tree().change_scene_to_file("res://User Interface/level_interface.tscn"))
