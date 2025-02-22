extends Node2D

@onready var Game_user_interface: CanvasLayer = $"Game User Interface"
@onready var Enemy_node: Node2D = $Enemy

@export var Level_list : Dictionary

var current_level : Level_Information

func Change_Scene() -> void:
	get_tree().change_scene_to_file("res://User Interface/level_interface.tscn")

func _ready() -> void:
	var wait_Scene : CanvasLayer = preload("res://Game Logic Parts/wait_scene.tscn").instantiate()
	add_child(wait_Scene)
	
	Enemy_node.Level_Completed.connect(func():
		var SaveFile : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")
		if Global.level_type.Level_number not in SaveFile.level_Played:
			SaveFile.level_Played.append(Global.level_type.Level_number)
		if Global.level_type.Reward != "" and Global.level_type.Reward not in SaveFile.Available_Buttons:
			SaveFile.Available_Buttons.append(Global.level_type.Reward)
		ResourceSaver.save(SaveFile,"user://SaveFiles/Level_Details.tres")
		var Level_Won : CanvasLayer = preload("res://Game Logic Parts/level_won.tscn").instantiate()
		add_child(Level_Won)
		await get_tree().create_timer(6).timeout
		call_deferred("Change_Scene")
	)
	Enemy_node.Update_Money.connect(func(extra):
		Game_user_interface.Money += extra 
		Game_user_interface.Money_Counter.text = "Money : " + str(Game_user_interface.Money)
	)
	Enemy_node.Player_Lost.connect(func():
		var Level_Lost : CanvasLayer = preload("res://Game Logic Parts/level_lost.tscn").instantiate()
		add_child(Level_Lost)
		await get_tree().create_timer(6).timeout
		call_deferred("Change_Scene")
	)
	
	await get_tree().create_timer(6).timeout
	
	Enemy_node.Add_Enemies()
