extends Node2D

@onready var Game_user_interface: CanvasLayer = $"Game User Interface"
@onready var Enemy_node: Node2D = $Enemy
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var Level_list : Dictionary

var current_level : Level_Information

func Change_Scene() -> void:
	get_tree().change_scene_to_file("res://User Interface/level_interface.tscn")

func _ready() -> void:
	Enemy_node.Level_Completed.connect(func():
		var SaveFile : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")
		if current_level.Level_number not in SaveFile.level_Played:
			SaveFile.level_Played.append(current_level.Level_number)
		if current_level.Reward != "" and current_level.Reward not in SaveFile.Available_Buttons:
			SaveFile.Available_Buttons.append(current_level.Reward)
		ResourceSaver.save(SaveFile,"user://SaveFiles/Level_Details.tres")
		await get_tree().create_timer(5).timeout
		call_deferred("Change_Scene")
	)
	Enemy_node.Update_Money.connect(func(extra):
		Game_user_interface.Money += extra 
		Game_user_interface.Money_Counter.text = "Money : " + str(Game_user_interface.Money)
	)
	Enemy_node.Player_Lost.connect(func():
		await get_tree().create_timer(5).timeout
		call_deferred("Change_Scene")
	)
	
	var level_S : Level_Selection = ResourceLoader.load("user://SaveFiles/Level_Details.tres")
	print_debug("Level: ",level_S.Current_Level)
	current_level = Level_list[level_S.Current_Level]
	Enemy_node.Enemy_Information[0]["amount"] = current_level.Torch_Amount
	Enemy_node.Enemy_Information[1]["amount"] = current_level.TNT_Amount
	Enemy_node.Enemy_Information[2]["amount"] = current_level.Barrel_Amount
	Game_user_interface.Money = current_level.Money_Required
	Game_user_interface.Money_Counter.text = "Money : " + str(Game_user_interface.Money)
	
	animation_player.play("Starting")
	await animation_player.animation_finished
	
	Enemy_node.Add_Enemies()
