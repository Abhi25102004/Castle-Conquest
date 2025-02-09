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
var Enemy_positions : Array[int] = [178, 364, 550, 736]
var PickUp : Array[Dictionary] = []
var Total_Enemies : int = 0
var Current_Enemies: int = 0
var Enemies_Killed : int = 0
var Pause_Spawn : bool = false

func Add_Enemies() -> void:
	for enemies in Enemy_Information:
		if enemies["amount"] > 0:
			PickUp.append(enemies)
			Total_Enemies += enemies["amount"]
	await get_tree().create_timer(5).timeout
	Creater_Enemy()

func Creater_Enemy() -> void:
	var Enemy_dict : Dictionary = PickUp.pick_random()
	var Enemy_character : Goblin_Class = Enemy_dict["scene"].instantiate()
	Enemy_character.global_position = Vector2(2000,Enemy_positions.pick_random())
	add_child(Enemy_character)
	Current_Enemies += 1
	Enemy_character.GoblinDied.connect(func(): 
		Enemies_Killed += 1
		if Total_Enemies == Enemies_Killed:
			Level_Completed.emit()
		Update_Money.emit(50))
	await get_tree().create_timer(Enemy_dict["delay"]).timeout
	if Current_Enemies != Total_Enemies:
		Creater_Enemy()

func Danger_Area_Entered(_area: Area2D) -> void:
	Player_Lost.emit()
