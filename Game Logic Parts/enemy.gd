extends Node2D

signal Level_Completed
signal Update_Money
signal Player_Lost

var Enemy_Information : Array[Dictionary] = [
	{
		"scene":preload("res://Characters/Goblin/torch.tscn"),
		"amount":0,
		"delay":5
	},
	{
		"scene":preload("res://Characters/Goblin/tnt.tscn"),
		"amount":0,
		"delay":10
	},
	{
		"scene":preload("res://Characters/Goblin/barrel.tscn"),
		"amount":0,
		"delay":15
	}
]

@onready var game_user_interface: CanvasLayer = $"../Game User Interface"

var Enemy_positions : Array = []
var PickUp : Array[Dictionary] = []
var Total_Enemies : int = 0
var Current_Enemies: int = 0
var Enemies_Killed : int = 0
var Pause_Spawn : bool = false

func Add_Enemies() -> void:
	Enemy_positions = $Markers.get_children()
	for enemies in Enemy_Information:
		if enemies["amount"] > 0:
			PickUp.append(enemies)
			Total_Enemies += enemies["amount"]
	await get_tree().create_timer(5).timeout
	game_user_interface.Progress_Bar_Setter(Total_Enemies)
	Creater_Enemy()

func Creater_Enemy() -> void:
	var Enemy_dict : Dictionary = PickUp.pick_random()
	var Enemy_character : Goblin_Class = Enemy_dict["scene"].instantiate()
	Enemy_character.global_position = Enemy_positions.pick_random().global_position
	add_child(Enemy_character)
	Current_Enemies += 1
	Enemy_character.GoblinDied.connect(func(extra): 
		Enemies_Killed += 1
		game_user_interface.Progress_Bar_Update(Enemies_Killed)
		if Total_Enemies == Enemies_Killed:
			Level_Completed.emit()
		Update_Money.emit(extra)
	)
	await get_tree().create_timer(Enemy_dict["delay"]).timeout
	if Current_Enemies != Total_Enemies:
		Creater_Enemy()

func Danger_Area_Entered(_area: Area2D) -> void:
	get_tree().call_group("Enemy","Character_Death")
	Player_Lost.emit()
