extends CanvasLayer

@onready var Level_Grid: GridContainer = %"Levels Container"
@onready var Animations: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var Level_Completed : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")
	Global.Buttons = Level_Completed.Available_Buttons
	for button in %"Levels Container".get_children():
		if button.Level_number == 1 or button.Level_number - 1 in Level_Completed.level_Played:
			button.pressed.connect(func():
				Global.level_type = button.get("Level_data")
				Animations.play("Switch_Animation")
				await Animations.animation_finished
				get_tree().change_scene_to_file("res://Test Scenes/test_world.tscn")
				)
		else:
			button.icon = preload("res://Assets/UI/Icons/Regular_10.png")

func Quit_Button() -> void:
	Animations.play("Switch_Animation")
	await Animations.animation_finished
	get_tree().change_scene_to_file("res://Main Logic/start_scene.tscn")
