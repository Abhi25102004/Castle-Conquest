extends Node

@onready var Game_user_interface: CanvasLayer = $"Game User Interface"
@onready var Enemy_node: Node2D = $Enemy
@onready var Animations: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Control/Label

@export var Level_list : Dictionary

var current_level : Level_Information

func Change_Scene() -> void:
	get_tree().change_scene_to_file("res://User Interface/level_interface.tscn")

func _ready() -> void:
	Animations.play("Please Wait")
	
	Enemy_node.Level_Completed.connect(func():
		Animations.play("Level Won")
		var SaveFile : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")
		if Global.level_type.Level_number not in SaveFile.level_Played:
			SaveFile.level_Played.append(Global.level_type.Level_number)
		if Global.level_type.Reward != "" and Global.level_type.Reward not in SaveFile.Available_Buttons:
			SaveFile.Available_Buttons.append(Global.level_type.Reward)
		ResourceSaver.save(SaveFile,"user://SaveFiles/Level_Details.tres")
		await Animations.animation_finished
		call_deferred("Change_Scene")
		)
	
	Enemy_node.Player_Lost.connect(func():
		Animations.play("Level Lost")
		await Animations.animation_finished
		call_deferred("Change_Scene")
		)
	
	Game_user_interface.quite_button.pressed.connect(func(): 
		Animations.play('Exit')
		await Animations.animation_finished
		get_tree().change_scene_to_file("res://User Interface/level_interface.tscn")
		)
	
	Game_user_interface.settings_button.pressed.connect(func():
		Animations.play('Exit')
		await Animations.animation_finished
		Global.Setting_Last_Scene = "res://Test Scenes/test_world.tscn"
		get_tree().change_scene_to_file("res://Game Logic Parts/settings_scene.tscn")
		)

func Level_Won() -> void:
	label.text = [
"Victory is thine!",
"Thou hast prevailed!",
"Glory is yours, brave one!",
"A noble triumph!",
"Huzzah! The battle is won!",
"By steel and valor, thou art victorious!",
"The land sings of thy deeds!"
].pick_random()

func Level_Lost() -> void:
	label.text = [
"Thy quest hath faltered...",
"Defeat stains thy banner...",
"The enemy hath bested thee...",
"Alas! Thy kingdom weeps...",
"Honor lost, but not forgotten...",
"A bitter loss, yet hope remains...",
"Thy foes feast whilst thy warriors fall..."
].pick_random()

func Please_Wait() -> void:
	label.text = [
"Patience, noble one...",
"Let time weave its course...",
"A moment’s respite, sire...",
"The fates must yet decide...",
"The scrolls are being scribed...",
"Hold fast, for destiny beckons...",
"Thy journey shall resume anon..."
].pick_random()
