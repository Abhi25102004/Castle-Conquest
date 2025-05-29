extends CanvasLayer

@onready var Animations: AnimationPlayer = $AnimationPlayer
@onready var blue_animation: AnimatedSprite2D = %Blue_Animation
@onready var red_animation: AnimatedSprite2D = %Red_Animation
@onready var yellow_animation: AnimatedSprite2D = %Yellow_Animation
@onready var purple_animation: AnimatedSprite2D = %Purple_Animation

@onready var color_animations: AnimatedSprite2D = $PanelContainer/Color
@onready var difficulty_animations: AnimatedSprite2D = $PanelContainer/Difficulty

@onready var easy_animations: AnimatedSprite2D = %Easy_Animations
@onready var medium_animations: AnimatedSprite2D = %Medium_Animations
@onready var hard_animations: AnimatedSprite2D = %Hard_Animations

@onready var Achievement_container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/TabContainer/Achievement/ScrollContainer/VBoxContainer

func _ready() -> void:
	color_animations.play(Global.Theme_color)
	difficulty_animations.play(Global.Difficulty)

	%Blue.pressed.connect(func(): Color_Change("Blue", blue_animation))
	%Red.pressed.connect(func(): Color_Change("Red", red_animation))
	%Yellow.pressed.connect(func(): Color_Change("Yellow", yellow_animation))
	%Purple.pressed.connect(func(): Color_Change("Purple", purple_animation))

	%Easy.pressed.connect(func(): Difficulty_Change("Easy", easy_animations))
	%Medium.pressed.connect(func(): Difficulty_Change("Medium", medium_animations))
	%Hard.pressed.connect(func(): Difficulty_Change("Hard", hard_animations))

	%Quit.pressed.connect(func():
		%Quit.disabled = true
		Animations.play_backwards("Entry")
		await Animations.animation_finished
		call_deferred("Change_Scene")
	)
	
	var Achievement_list : Achievement_Save = ResourceLoader.load("user://Achievement_File.tres")
	var Achievement_Dict : Dictionary = Achievement_list.Achievements
	var Achievement_scene : PackedScene = preload("res://Extra Scenes/achievement_panel.tscn")
	for numbers in Achievement_Dict.keys():
		var Achievement_Struct : Dictionary = Achievement_Dict.get(numbers)
		var Achievement : PanelContainer = Achievement_scene.instantiate()
		Achievement.name_ = Achievement_Struct.get("name")
		Achievement.description = Achievement_Struct.get("description")
		Achievement.completed_ = Achievement_Struct.get("completed")
		Achievement_container.add_child(Achievement)

func Change_Scene() -> void:
	if is_inside_tree():
		get_tree().change_scene_to_file(Global.Setting_Last_Scene)

func Color_Change(color : String , Animations_image : AnimatedSprite2D) -> void:
	Global.Theme_color = color

	var Settings_File : Settings_Save = ResourceLoader.load("user://Settings_File.tres")
	Settings_File.Player_Colour = color
	ResourceSaver.save(Settings_File,"user://Settings_File.tres")
	
	Animations_image.play("Attack")
	await Animations_image.animation_finished
	color_animations.play(Global.Theme_color)
	Animations_image.play("default")

func Difficulty_Change(difficulty : String, Animations_image : AnimatedSprite2D) -> void:
	Global.Difficulty = difficulty
	Global.Setting_Last_Scene = "res://Main Game Scenes/level_interface.tscn"
	
	var Settings_File : Settings_Save = ResourceLoader.load("user://Settings_File.tres")
	Settings_File.Game_Mode = difficulty
	ResourceSaver.save(Settings_File,"user://Settings_File.tres")
	
	Animations_image.play("Attack")
	await Animations_image.animation_finished
	difficulty_animations.play(Global.Difficulty)
	Animations_image.play("default")
