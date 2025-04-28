extends Node

@onready var Game_user_interface: CanvasLayer = $"Game User Interface"
@onready var Enemy_node: Node2D = $Enemy
@onready var Animations: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Control/Label
@onready var level_node: Node2D = $Level_Node

@export var Level_list : Dictionary

var current_level : Level_Information

func Change_Scene(Change_file: String) -> void:
	if not is_inside_tree():
		return
	get_tree().change_scene_to_file(Change_file)

func _ready() -> void:
	Animations.play("Please Wait")

	level_node.add_child(Global.level_type.Level_Scene.instantiate())

	Enemy_node.Level_Completed.connect(func():
		Animations.play("Level Won")
		
		var SaveFile : Level_Selection = ResourceLoader.load("user://Level_Details.tres")
		
		if Global.level_type.Level_number not in SaveFile.level_Played:
			SaveFile.level_Played.append(Global.level_type.Level_number)
		
		if Global.level_type.Level_number not in SaveFile.Difficulty_played[Global.Difficulty]:
			SaveFile.Difficulty_played[Global.Difficulty].append(Global.level_type.Level_number)

		if Global.level_type.Reward != "" and Global.level_type.Reward not in SaveFile.Available_Buttons:
			SaveFile.Available_Buttons.append(Global.level_type.Reward)

		ResourceSaver.save(SaveFile,"user://Level_Details.tres")
		
		await Animations.animation_finished
		
		if Global.level_type.Level_number == 10:
			call_deferred("Change_Scene", "res://Main Game Scenes/end_credit_scene.tscn")
		else:
			call_deferred("Change_Scene", "res://Main Game Scenes/level_interface.tscn")
	)

	Enemy_node.Player_Lost.connect(func():
		Animations.play("Level Lost")
		await Animations.animation_finished
		call_deferred("Change_Scene", "res://Main Game Scenes/level_interface.tscn")
	)

	Game_user_interface.quite_button.pressed.connect(func(): 
		Animations.play("Exit")
		await Animations.animation_finished
		call_deferred("Change_Scene", "res://Main Game Scenes/level_interface.tscn")
	)

	Game_user_interface.settings_button.pressed.connect(func():
		Animations.play("Exit")
		await Animations.animation_finished
		Global.Setting_Last_Scene = "res://Main Game Scenes/Gamplay Scene.tscn"
		call_deferred("Change_Scene", "res://Main Game Scenes/settings_scene.tscn")
	)

func Level_Won() -> void:
	randomize()
	label.text = [
		"Victory was yours.",
		"The battle ended in your favor.",
		"Against all odds, triumph was achieved.",
		"The win belonged to you.",
		"Success found its way to you.",
		"There was no denying your dominance.",
		"The contest saw you as the victor.",
		"A glorious win marked your journey.",
	].pick_random()

func Level_Lost() -> void:
	randomize()
	label.text = [
		"Defeat was yours.",
		"The battle ended in your loss.",
		"The outcome did not favor you.",
		"Victory slipped from your grasp.",
		"The fight ended with your downfall.",
		"The other side claimed the win.",
		"Triumph was denied to you.",
		"The contest concluded in your defeat.",
		"The odds overwhelmed your efforts.",
		"In the end, your side fell short."
	].pick_random()

func Please_Wait() -> void:
	randomize()
	label.text = [
		"Your patience is appreciated.",
		"Kindly bear with me.",
		"Hang in there for a moment.",
		"I ask for your understanding.",
		"Just a little more patience, please.",
		"Thank you for waiting.",
		"Please hold on for a bit.",
		"I appreciate your patience.",
		"Give me a moment, if you don’t mind.",
		"Patience would mean a lot right now."
	].pick_random()

func Add_Battle_Music() -> void:
	call_deferred("add_child",preload("res://Main Game Scenes/battle_music.tscn").instantiate())

func Play_Song() -> void:
	MainMusic.play()

func Pause_Song() -> void:
	MainMusic.stop()
