extends CanvasLayer

@onready var Animations: AnimationPlayer = $AnimationPlayer
@onready var blue_animation: AnimatedSprite2D = %Blue_Animation
@onready var red_animation: AnimatedSprite2D = %Red_Animation
@onready var yellow_animation: AnimatedSprite2D = %Yellow_Animation
@onready var purple_animation: AnimatedSprite2D = %Purple_Animation
@onready var Color_Lable: Label = $"PanelContainer/MarginContainer/VBoxContainer/TabContainer/Character Color/Label2"
@onready var Difficulty_Lable: Label = $"PanelContainer/MarginContainer/VBoxContainer/TabContainer/Game Difficulty/Label2"
@onready var easy_animations: AnimatedSprite2D = %Easy_Animations
@onready var medium_animations: AnimatedSprite2D = %Medium_Animations
@onready var hard_animations: AnimatedSprite2D = %Hard_Animations

func _ready() -> void:
	
	Color_Lable.text = "Current Color : " + Global.Theme_color
	Difficulty_Lable.text = "Current Difficulty : " + Global.Difficulty
	
	%Blue.pressed.connect(func(): Color_Change("Blue",blue_animation))
		
	%Red.pressed.connect(func(): Color_Change("Red",red_animation))
		
	%Yellow.pressed.connect(func(): Color_Change("Yellow",yellow_animation))
		
	%Purple.pressed.connect(func(): Color_Change("Purple",purple_animation))
	
	%Easy.pressed.connect(func(): Difficulty_Change("Easy",easy_animations))
		
	%Medium.pressed.connect(func(): Difficulty_Change("Medium",medium_animations))
		
	%Hard.pressed.connect(func(): Difficulty_Change("Hard",hard_animations))
	
	%Quit.pressed.connect(func(): 
		Animations.play_backwards("Entry")
		await Animations.animation_finished
		call_deferred("Change_Scene")
		)

func Change_Scene() -> void:
	get_tree().change_scene_to_file(Global.Setting_Last_Scene)

func Color_Change(color : String , Animations_image : AnimatedSprite2D) -> void:
	Global.Theme_color = color
	Color_Lable.text = "Current Color : " + Global.Theme_color
	var SaveFile : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")
	SaveFile.Color_String = color
	ResourceSaver.save(SaveFile,"user://SaveFiles/Level_Details.tres")
	Animations_image.play("Attack")
	await Animations_image.animation_finished
	Animations_image.play("default")

func Difficulty_Change(difficulty : String, Animations_image : AnimatedSprite2D) -> void:
	Global.Difficulty = difficulty
	Difficulty_Lable.text = "Current Difficulty : " + difficulty
	var SaveFile : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")
	SaveFile.Game_Difficulty = difficulty
	ResourceSaver.save(SaveFile,"user://SaveFiles/Level_Details.tres")
	Animations_image.play("Attack")
	await Animations_image.animation_finished
	Animations_image.play("default")
