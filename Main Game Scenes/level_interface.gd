extends CanvasLayer

@onready var Level_Grid: GridContainer = %"Levels Container"
@onready var Animations: AnimationPlayer = $AnimationPlayer
@onready var color_animations: AnimatedSprite2D = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/Color
@onready var difficulty_animations: AnimatedSprite2D = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/Difficulty

func Change_Scene(scene : String) -> void:
	get_tree().change_scene_to_file(scene)

func _ready() -> void:
	color_animations.play(Global.Theme_color)
	difficulty_animations.play(Global.Difficulty)
	
	var Level_Completed : Level_Selection = ResourceLoader.load("user://Level_Details.tres")
	var Level_Available : Array = Level_Completed.Difficulty_played[Global.Difficulty]
	for button in %"Levels Container".get_children():
		if button.Level_number == 1 or button.Level_number - 1 in Level_Available:
			button.pressed.connect(func():
				Global.level_type = button.get("Level_data")
				Animations.play("Switch_Scene")
				await Animations.animation_finished
				call_deferred("Change_Scene","res://Main Game Scenes/Gamplay Scene.tscn")
				)
		else:
			button.text = ""
			button.icon = preload("res://Assets/UI/Icons/Regular_10.png")

func Quit_Button() -> void:
	Animations.play("Switch_Scene")
	await Animations.animation_finished
	call_deferred("Change_Scene","res://Main Game Scenes/start_scene.tscn")
