extends Node2D

signal Level_Completed
signal Player_Lost

var Enemy_positions : Array[int] = [221, 407, 593, 779]

var Waves : Array[Wave] = [
	Global.level_type.Wave3,
	Global.level_type.Wave2,
	Global.level_type.Wave1
]

var Current_wave : Wave

var Enemies_instance_array : Array[Goblin_Class]

var Delay : float = Global.level_type.Level_Delay

var Marker : int
var Perivious_marker : int

var Priority_Array : Array[float] = [0, 0, 0, 0]

var Total_Enemies : int

var Enemies_Killed : int

var Total_Enemies_killed : int

var Selection_array : Array[int]

@onready var EnemeyAI: Node2D = $"Enemy AI area"

func _ready() -> void:
	for enemy_area in EnemeyAI.get_children():
		if enemy_area is Enemy_Area:
			enemy_area.Update_Priority.connect(func(value : float):
				Priority_Array[EnemeyAI.get_children().find(enemy_area)] = value
			)
	
	Start_adding_enemies()

func Start_adding_enemies() -> void:
	Enemies_Killed = 0
	Enemies_instance_array = []

	Current_wave = Waves.pop_back() as Wave

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

		Enemy.global_position = Vector2(2000, Enemy_positions[Selection_array.pick_random()])
		call_deferred("add_child", Enemy)

		Enemy.GoblinDied.connect(func():
			Global.Progress.emit()
			Enemies_Killed += 1
			Total_Enemies_killed += 1
			if Total_Enemies == Enemies_Killed:
				if Total_Enemies_killed == Global.level_type.Game_Total_Enemies:
					await get_tree().create_timer(1.5).timeout
					Level_Completed.emit()
				else:
					Start_adding_enemies()
					Creater_Enemy()
		)

		await get_tree().create_timer(Delay).timeout
		Creater_Enemy()

func Danger_Area_Entered(_area: Area2D) -> void:
	get_tree().call_group("Enemy", "Character_Death")
	Player_Lost.emit()

func Enemy_Death_Zone_Entered(area: Area2D) -> void:
	if area.get_parent() is Goblin_Class:
		area.get_parent().Health = 0
