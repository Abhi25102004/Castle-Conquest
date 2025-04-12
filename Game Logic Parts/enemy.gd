extends Node2D

# Signals emitted when the level is completed or the player loses
signal Level_Completed
signal Player_Lost

# Positions (Y-values) at which enemies can be spawned
var Enemy_positions : Array[int] = [221, 407, 593, 779]

# Predefined waves of enemies (from hardest to easiest)
var Waves : Array[Wave] = [
	Global.level_type.Wave3,
	Global.level_type.Wave2,
	Global.level_type.Wave1
]

# Current active wave of enemies
var Current_wave : Wave

# Stores instances of enemies to be spawned
var Enemies_instance_array : Array[Goblin_Class]

# Delay between spawning enemies
var Delay : float = Global.level_type.Level_Delay

# Marker to track spawning progress (optional usage)
var Marker : int
var Perivious_marker : int

# Stores priority values for each lane (0–3)
var Priority_Array : Array[float] = [0, 0, 0, 0]

# Total number of enemies in the current wave
var Total_Enemies : int

# Count of how many enemies have been killed
var Enemies_Killed : int

# Stores lanes (indexes) with the lowest priority (used for spawn decisions)
var Selection_array : Array[int]

# Reference to the node containing lane-based enemy AI zones
@onready var EnemeyAI: Node2D = $"Enemy AI area"

func _ready() -> void:
	"""
	Initializes the enemy priority tracking system and begins spawning enemies.
	"""
	for enemy_area in EnemeyAI.get_children():
		if enemy_area is Enemy_Area:
			# Connects each enemy area's priority update to the Priority_Array
			enemy_area.Update_Priority.connect(func(value : float):
				Priority_Array[EnemeyAI.get_children().find(enemy_area)] = value
			)
	
	Start_adding_enemies()

func Start_adding_enemies() -> void:
	"""
	Starts the next wave by loading enemy instances into the spawn array.
	"""
	Total_Enemies = 0
	Enemies_Killed = 0
	Enemies_instance_array = []

	# Get the next wave (last in list)
	Current_wave = Waves.pop_back() as Wave

	# Preload and queue enemy instances based on wave configuration
	for i in range(Current_wave.Number_of_torch):
		Enemies_instance_array.append(preload("res://Characters/Goblin/torch.tscn").instantiate())
	for i in range(Current_wave.Number_of_tnt):
		Enemies_instance_array.append(preload("res://Characters/Goblin/tnt.tscn").instantiate())
	for i in range(Current_wave.Number_of_barrel):
		Enemies_instance_array.append(preload("res://Characters/Goblin/barrel.tscn").instantiate())

	Total_Enemies = Current_wave.Number_of_torch + Current_wave.Number_of_tnt + Current_wave.Number_of_barrel

func Add_Enemies() -> void:
	"""
	Triggers the enemy creation logic.
	"""
	Creater_Enemy()

func Creater_Enemy() -> void:
	"""
	Spawns a single enemy in a lane with the lowest priority.
	Continues recursively after a delay until all enemies are spawned.
	"""
	if !Enemies_instance_array.is_empty():
		var Enemy : Goblin_Class = Enemies_instance_array.pick_random() as Goblin_Class
		Enemies_instance_array.erase(Enemy)

		# Find all lanes with the lowest priority value
		Selection_array = []
		var min_value : int = Priority_Array.min()
		for i in range(4):
			if min_value == Priority_Array[i]:
				Selection_array.append(i)

		randomize()

		# Set enemy spawn position and add to scene
		Enemy.global_position = Vector2(2000, Enemy_positions[Selection_array.pick_random()])
		call_deferred("add_child", Enemy)

		# Connect death signal to progress tracking
		Enemy.GoblinDied.connect(func():
			Enemies_Killed += 1
			if Total_Enemies == Enemies_Killed:
				if Waves.is_empty():
					await get_tree().create_timer(1).timeout
					Level_Completed.emit()
				else:
					Start_adding_enemies()
					Creater_Enemy()
		)

		# Wait for the delay, then spawn the next enemy
		await get_tree().create_timer(Delay).timeout
		Creater_Enemy()

func Danger_Area_Entered(_area: Area2D) -> void:
	"""
	Triggered when an enemy enters a danger zone.
	Kills all enemies and signals player loss.
	"""
	get_tree().call_group("Enemy", "Character_Death")
	Player_Lost.emit()

func Enemy_Death_Zone_Entered(area: Area2D) -> void:
	"""
	Triggered when an enemy enters the kill zone.
	Forces the enemy to die instantly.
	"""
	if area.get_parent() is Goblin_Class:
		area.get_parent().Health = 0
