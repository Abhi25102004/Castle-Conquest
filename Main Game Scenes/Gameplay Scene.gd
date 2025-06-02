extends Node

@onready var Game_user_interface: CanvasLayer = $"Game User Interface"
@onready var Enemy_node: Node2D = $Enemy
@onready var Animations: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Control/Label
@onready var level_node: Node2D = $Level_Node

func Change_Scene(Change_file: String) -> void:
	if is_inside_tree():
		get_tree().change_scene_to_file(Change_file)

func _ready() -> void:

	Animations.play("Please Wait")

	level_node.add_child(Global.level_type.Level_Scene.instantiate())

	Enemy_node.Level_Completed.connect(func():
		Animations.play("Level Won")

		var Save : SaveFile = ResourceLoader.load("user://Save_File.tres")

		if Global.level_type.Level_number not in Save.level_Played:
			Save.level_Played.append(Global.level_type.Level_number)

		if Global.level_type.Level_number not in Save.Difficulty_played[Global.Difficulty]:
			Save.Difficulty_played[Global.Difficulty].append(Global.level_type.Level_number)

		if Global.level_type.Reward != "" and Global.level_type.Reward not in Save.Available_Buttons:
			Save.Available_Buttons.append(Global.level_type.Reward)

		ResourceSaver.save(Save,"user://Save_File.tres")
		
		var Achievement_list : Achievement_Save = ResourceLoader.load("user://Achievement_File.tres")
		var Achievement_Dict : Dictionary = Achievement_list.Achievements
		for numbers in Achievement_Dict.keys():
			match numbers:
				1:
					if 1 in Save.level_Played:
						Achievement_list.Achievements[numbers]["completed"] = true
				2:
					if 10 in Save.level_Played:
						Achievement_list.Achievements[numbers]["completed"] = true
				3:
					if Save.Difficulty_played["Easy"].size() == 20:
						Achievement_list.Achievements[numbers]["completed"] = true
				4:
					if Save.Difficulty_played["Medium"].size() == 20:
						Achievement_list.Achievements[numbers]["completed"] = true
				5:
					if Save.Difficulty_played["Hard"].size() == 20:
						Achievement_list.Achievements[numbers]["completed"] = true
			
			ResourceSaver.save(Achievement_list,"user://Achievement_File.tres")

		await Animations.animation_finished
		

		if Global.level_type.Level_number == 20:
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
		Game_user_interface.quite_button.disabled = true
		Animations.play("Exit")
		await Animations.animation_finished
		call_deferred("Change_Scene", "res://Main Game Scenes/level_interface.tscn")
	)

	Game_user_interface.settings_button.pressed.connect(func():
		Game_user_interface.settings_button.disabled = true
		Animations.play("Exit")
		await Animations.animation_finished
		Global.Setting_Last_Scene = "res://Main Game Scenes/Gameplay Scene.tscn"
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
