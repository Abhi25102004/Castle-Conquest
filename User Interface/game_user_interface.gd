extends CanvasLayer

@onready var Placement_Buttons: GridContainer = $Middle/GridContainer
@onready var Character_Buttons: HBoxContainer = $Bottom/HBoxContainer
@onready var Money_Counter: Label = $Header/Label
@onready var Wave_label: Label = $Header/Label2
@onready var quite_button: Button = %"Quite Button"
@onready var settings_button: Button = %"Settings Button"

var cost : int = 0
var Character_Scene : PackedScene = null
var Money : int = Global.level_type.Money_Required
var canRemove : bool = false

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

func _ready() -> void:
	Money_Counter.text = "Money : " + str(Money) 
	
	for child in Placement_Buttons.get_children():
		if child is Button:
			child.pressed.connect(Placement_Button_Pressed.bind(child))
	
	for child in Character_Buttons.get_children():
		if child is Button and child.name in Global.Buttons:
			child.visible = true
			child.pressed.connect(Add_Character.bind(child))
	
	Global.connect("Add_Money",func(extra : int):
		Money += extra
		Money_Counter.text = "Money : " + str(Money) 
		)
	
	Global.connect("Update_Wave",func(text : String):
		Wave_label.text = "Wave : " + text
		)
