extends CanvasLayer

@onready var Placement_Buttons: GridContainer = $Middle/GridContainer
@onready var Character_Buttons: HBoxContainer = $Bottom/HBoxContainer
@onready var Money_Counter: Label = $Header/Label
@onready var quite_button: Button = %"Quite Button"
@onready var settings_button: Button = %"Settings Button"
@onready var Animations: AnimatedSprite2D = $Header/Label/AnimatedSprite2D
@onready var progress_bar: ProgressBar = $Header/Panel/VBoxContainer/ProgressBar

var cost : int = 0

var Character_Scene : PackedScene = null

var Money : int = Global.level_type.Money_Required

func _ready() -> void:
	Money_Counter.text = str(Money)

	progress_bar.max_value = Global.level_type.Game_Total_Enemies
	progress_bar.value = 0

	for placement_button in Placement_Buttons.get_children():
		if placement_button is Button:
			placement_button.pressed.connect(func():
				if Character_Scene and Money >= cost:
					placement_button.Add_Scene(Character_Scene)
					Global.Remove_Money.emit(cost)
				elif !Character_Scene:
					placement_button.Remove_child()
				
				Character_Scene = null
				cost = 0
			)

	for character_button in Character_Buttons.get_children():
		if character_button.name in Global.Buttons:
			character_button.visible = true
			character_button.pressed.connect(func():
				await get_tree().process_frame
				Character_Scene = character_button.Scene
				cost = character_button.value
			)
		else:
			character_button.visible = false

	Global.connect("Add_Money", func(extra : int):
		Animations.play("Coin Added")
		Money += extra
		Money_Counter.text = str(Money)
	)

	Global.connect("Remove_Money", func(extra : int):
		Money = (Money - extra) if (Money - extra) >= 0 else 0
		Money_Counter.text = str(Money)
	)

	Global.Progress.connect(func(value : int):
		progress_bar.value = value
		)
