extends Node2D

signal Level_Completed
signal Player_Lost

@export var Enemy_positions : Array[int]

var Waves : Array[Wave] = [
	Global.level_type.Wave3,
	Global.level_type.Wave2,
	Global.level_type.Wave1
]

var Current_wave : Wave
var Enemies_instance_array : Array[Goblin_Class]
var Delay : int
var Marker : int
var Perivious_marker : int
var Priority_Array : Array[float] = [0,0,0,0]
var Total_Enemies : int
var Enemies_Killed : int
var Selection_array : Array[int]

func _ready() -> void:
	Start_adding_enemies()

func Start_adding_enemies() -> void:
	Total_Enemies = 0
	Enemies_Killed = 0
	Enemies_instance_array = []
	Current_wave = Waves.pop_back() as Wave
	Delay = Current_wave.Wave_delay
	for i in range(Current_wave.Number_of_torch):
		Enemies_instance_array.append(preload("res://Characters/Goblin/torch.tscn").instantiate())
	for i in range(Current_wave.Number_of_tnt):
		Enemies_instance_array.append(preload("res://Characters/Goblin/tnt.tscn").instantiate())
	for i in range(Current_wave.Number_of_barrel):
		Enemies_instance_array.append(preload("res://Characters/Goblin/barrel.tscn").instantiate())
	Total_Enemies = Current_wave.Number_of_torch + Current_wave.Number_of_tnt + Current_wave.Number_of_barrel

func Add_Enemies() -> void:
	Creater_Enemy()

func Creater_Enemy() -> void:
	if !Enemies_instance_array.is_empty():
		var Enemy : Goblin_Class = Enemies_instance_array.pick_random() as Goblin_Class
		Enemies_instance_array.erase(Enemy)
		Selection_array = []
		var min_value : int = Priority_Array.min()
		for i in range(4):
			if min_value == Priority_Array[i]:
				Selection_array.append(i)
		randomize()
		Enemy.global_position = Vector2(2000,Enemy_positions[Selection_array.pick_random()])
		call_deferred("add_child",Enemy)
		Enemy.GoblinDied.connect(func():
			Enemies_Killed += 1
			if Total_Enemies == Enemies_Killed:
				if Waves.is_empty():
					Level_Completed.emit()
				else:
					Start_adding_enemies()
					Creater_Enemy()
			)
		await get_tree().create_timer(Delay).timeout
		Creater_Enemy()

func Danger_Area_Entered(_area: Area2D) -> void:
	get_tree().call_group("Enemy","Character_Death")
	Player_Lost.emit()

func Updated_Priority_Area1(value : int) -> void:
	Priority_Array[0] = value

func Updated_Priority_Area2(value : int) -> void:
	Priority_Array[1] = value

func Updated_Priority_Area3(value : int) -> void:
	Priority_Array[2] = value

func Updated_Priority_Area4(value : int) -> void:
	Priority_Array[3] = value

func Enemy_Death_Zone_Entered(area: Area2D) -> void:
	area.get_parent().call_deferred("queue_free")
