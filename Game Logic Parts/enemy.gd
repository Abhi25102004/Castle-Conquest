extends Node2D

signal Level_Completed
signal Player_Lost

var Wave_number : int = 1
var Waves : Array[Wave] = [
	Global.level_type.Wave3,
	Global.level_type.Wave2,
	Global.level_type.Wave1
]
var Enemy_positions : Array = []
var Number_of_enemies : Dictionary = {
	"torch":0,
	"tnt":0,
	"barrel":0
}
var Current_wave : Wave
var Enemies_instance_array : Array[Goblin_Class] = []
var Total_Enemies : int = 0
var Current_Enemies: int = 0
var Enemies_Killed : int = 0
var Delay : int
var Marker : Marker2D = null
var Perivious_marker : Marker2D = null
var Enemy_scenes : Dictionary = {
	"torch":preload("res://Characters/Goblin/torch.tscn"),
	"tnt":preload("res://Characters/Goblin/tnt.tscn"),
	"barrel":preload("res://Characters/Goblin/barrel.tscn")
}

func _ready() -> void:
	Enemy_positions = $Markers.get_children()
	Start_adding_enemies()

func Start_adding_enemies() -> void:
	Global.emit_signal("Update_Wave",str(Wave_number))
	Enemies_instance_array = []
	Total_Enemies = 0
	Current_Enemies = 0
	Enemies_Killed = 0
	Current_wave = Waves.pop_back() as Wave
	Delay = Current_wave.Wave_delay
	Number_of_enemies = {
		"torch":Current_wave.Number_of_torch,
		"tnt":Current_wave.Number_of_tnt,
		"barrel":Current_wave.Number_of_barrel
	}
	for enemies in Number_of_enemies.keys():
		if  Number_of_enemies.get(enemies) > 0:
			for i in range(Number_of_enemies.get(enemies)):
				Enemies_instance_array.append(Enemy_scenes.get(enemies).instantiate())
			Total_Enemies += Number_of_enemies.get(enemies)

func Add_Enemies() -> void:
	Creater_Enemy()

func Creater_Enemy() -> void:
	if !Enemies_instance_array.is_empty():
		var Enemy : Goblin_Class = Enemies_instance_array.pick_random() as Goblin_Class
		Enemies_instance_array.erase(Enemy)
		Marker = Enemy_positions.pick_random() as Marker2D
		while Marker == Perivious_marker:
			Marker = Enemy_positions.pick_random()
		Enemy.global_position = Marker.global_position
		Perivious_marker = Marker
		call_deferred("add_child",Enemy)
		Current_Enemies += 1
		Enemy.GoblinDied.connect(func():
			Enemies_Killed += 1
			if Total_Enemies == Enemies_Killed:
				if Waves.is_empty():
					Level_Completed.emit()
				else:
					Wave_number += 1
					Start_adding_enemies()
					Creater_Enemy()
		)
		await get_tree().create_timer(Delay).timeout
		if Current_Enemies != Total_Enemies:
			Creater_Enemy()

func Danger_Area_Entered(_area: Area2D) -> void:
	get_tree().call_group("Enemy","Character_Death")
	Player_Lost.emit()
