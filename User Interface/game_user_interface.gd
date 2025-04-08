extends CanvasLayer

# UI references using `@onready` to ensure they are valid after the node is added to the scene
@onready var Placement_Buttons: GridContainer = $Middle/GridContainer
@onready var Character_Buttons: HBoxContainer = $Bottom/HBoxContainer
@onready var Money_Counter: Label = $Header/Label
@onready var quite_button: Button = %"Quite Button"
@onready var settings_button: Button = %"Settings Button"
@onready var Animations: AnimatedSprite2D = $Header/Label/AnimatedSprite2D
@onready var progress_bar: ProgressBar = $Header/Panel/VBoxContainer/ProgressBar

# Current cost of the selected character
var cost : int = 0

# The character scene selected to be placed
var Character_Scene : PackedScene = null

# The current amount of money available to the player
var Money : int = Global.level_type.Money_Required

func _ready() -> void:
	"""
	Initializes the HUD, including:
	- Displaying money
	- Setting up progress bar
	- Connecting buttons and global signals
	"""
	
	# Initialize money label
	Money_Counter.text = str(Money)

	# Setup progress bar with max number of enemies
	progress_bar.max_value = Global.level_type.Game_Total_Enemies
	progress_bar.value = 0

	# Connect all placement buttons to handle placing or removing a character
	for placement_button in Placement_Buttons.get_children():
		if placement_button is Button:
			placement_button.pressed.connect(func():
				if Character_Scene and Money >= cost:
					# Place the selected character if enough money
					placement_button.Add_Scene(Character_Scene)
					Global.Remove_Money.emit(cost)
				elif !Character_Scene:
					# Remove a placed character
					placement_button.Remove_child()
				
				# Reset selection
				Character_Scene = null
				cost = 0
			)

	# Configure character buttons based on availability from Global.Buttons
	for character_button in Character_Buttons.get_children():
		if character_button.name in Global.Buttons:
			character_button.visible = true
			character_button.pressed.connect(func():
				await get_tree().process_frame  # Wait a frame to ensure button state updates
				Character_Scene = character_button.Scene
				cost = character_button.value
			)
		else:
			character_button.visible = false

	# Respond to money gain
	Global.connect("Add_Money", func(extra : int):
		Animations.play("Coin Added")
		Money += extra
		Money_Counter.text = str(Money)
	)

	# Respond to money deduction
	Global.connect("Remove_Money", func(extra : int):
		Money = (Money - extra) if (Money - extra) >= 0 else 0
		Money_Counter.text = str(Money)
	)

	# Update progress bar when an enemy is defeated or progress is made
	Global.Progress.connect(func():
		progress_bar.value += 1
	)
