extends CanvasLayer

@onready var Level_Grid: GridContainer = %"Levels Container"
@onready var Animations: AnimationPlayer = $AnimationPlayer
@onready var color_animations: AnimatedSprite2D = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/Color
@onready var difficulty_animations: AnimatedSprite2D = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/Difficulty
@onready var achievement_panel: PanelContainer = $Achievement_Panel
@onready var quit: Button = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/Quit
@onready var endless_mode: Button = %"Endless Mode"

func Change_Scene(Change_file: String) -> void:
	if is_inside_tree():
		get_tree().change_scene_to_file(Change_file)

func _ready() -> void:
	var Save : SaveFile = ResourceLoader.load("user://Save_File.tres")
	endless_mode.text = "Endless Mode\nHigh Score : " + str(Save.Endless_High_Score)
	
	var Saved_settings_file : Settings_Save = ResourceLoader.load("user://Settings_File.tres")
	Global.Difficulty = Saved_settings_file.Game_Mode
	
	Animations.play("Entery")
	
	color_animations.play(Global.Theme_color)
	difficulty_animations.play(Global.Difficulty)

	var Level_Completed : SaveFile = ResourceLoader.load("user://Save_File.tres")
	var Level_Available : Array = Level_Completed.Difficulty_played[Global.Difficulty]
	
	endless_mode.pressed.connect(func():
		endless_mode.disabled = true
		Global.Endless = true
		Global.Difficulty = "Easy"
		Global.level_type = preload("res://Level Scenes and Data/Level Resources/Endless_Mode.tres")
		call_deferred("Change_Scene","res://Main Game Scenes/Gameplay Scene.tscn")
		)
	
	for button in %"Levels Container".get_children():
		if button.Level_number == 1 or button.Level_number - 1 in Level_Available:
			button.pressed.connect(func():
				button.disabled = true
				Global.Endless = false
				Global.level_type = button.get("Level_data")
				Animations.play("Switch_Scene")
				await Animations.animation_finished
				call_deferred("Change_Scene","res://Main Game Scenes/Gameplay Scene.tscn")
				)
		else:
			button.text = ""
			button.icon = preload("res://Assets/UI/Icons/Regular_10.png")
	
	await Animations.animation_finished
	
	var Achievement_list : Achievement_Save = ResourceLoader.load("user://Achievement_File.tres")
	for numbers in Achievement_list.Achievements.keys():
		var Achievement_Struct : Dictionary = Achievement_list.Achievements.get(numbers)
		if Achievement_Struct.get("completed") and !Achievement_Struct.get("notified"):
			achievement_panel.name_ = Achievement_Struct.get("name")
			achievement_panel.description = Achievement_Struct.get("description")
			achievement_panel.completed_ = true
			achievement_panel.Set_Values()
			Achievement_list.Achievements[numbers]["notified"] = true
			ResourceSaver.save(Achievement_list, "user://Achievement_File.tres")
			Animations.play("Notification")
			await Animations.animation_finished

func Quit_Button() -> void:
	quit.disabled = true
	Animations.play("Switch_Scene")
	await Animations.animation_finished
	call_deferred("Change_Scene","res://Main Game Scenes/start_scene.tscn")
