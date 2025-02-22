extends Node2D

signal Level_Completed
signal Update_Money
signal Player_Lost

@onready var game_user_interface: CanvasLayer = $"../Game User Interface"

var Enemy_scenes : Dictionary = {
	"torch":preload("res://Characters/Goblin/torch.tscn"),
	"tnt":preload("res://Characters/Goblin/tnt.tscn"),
	"barrel":preload("res://Characters/Goblin/barrel.tscn")
}
var Number_of_enemies : Dictionary = {
	"torch":Global.level_type.Torch_Amount,
	"tnt":Global.level_type.TNT_Amount,
	"barrel":Global.level_type.Barrel_Amount
}
var Enemies_instance_array : Array[Goblin_Class] = []
var Enemy_positions : Array = []
var Total_Enemies : int = 0
var Current_Enemies: int = 0
var Enemies_Killed : int = 0

func Add_Enemies() -> void:
	Creater_Enemy()

func Creater_Enemy() -> void:
	if !Enemies_instance_array.is_empty():
		var Enemy : Goblin_Class = Enemies_instance_array.pick_random()
		Enemies_instance_array.erase(Enemy)
		Enemy.global_position = Enemy_positions.pick_random().global_position
		add_child(Enemy)
		Current_Enemies += 1
		Enemy.GoblinDied.connect(func(extra): 
			Enemies_Killed += 1
			game_user_interface.Progress_Bar_Update(Enemies_Killed)
			if Total_Enemies == Enemies_Killed:
				Level_Completed.emit()
			Update_Money.emit(extra)
		)
		await get_tree().create_timer(10).timeout
		if Current_Enemies != Total_Enemies:
			Creater_Enemy()

func Danger_Area_Entered(_area: Area2D) -> void:
	get_tree().call_group("Enemy","Character_Death")
	Player_Lost.emit()

func _ready() -> void:
	Enemy_positions = $Markers.get_children()
	for enemies in Number_of_enemies.keys():
		if  Number_of_enemies.get(enemies) > 0:
			for i in range(Number_of_enemies.get(enemies)):
				Enemies_instance_array.append(Enemy_scenes.get(enemies).instantiate())
			Total_Enemies += Number_of_enemies.get(enemies)
	game_user_interface.Progress_Bar_Setter(Total_Enemies)
