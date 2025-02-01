extends Node2D

signal Add_Money

@export var Enemy_Collection : Array[Dictionary] = []
@export var Enemy_positions : Array[int] = []
@export var Enemy_numbers : Array[Dictionary] = []
@export var wait_time : float = 0

func Create_Drop() -> void:
	Add_Money.emit()

func _process(delta: float) -> void:
	wait_time -= delta
	if wait_time <= 0:
		var Enemy_dict : Dictionary = Enemy_Collection.pick_random()
		var Enemy_character : Node2D = Enemy_dict["scene"].instantiate()
		wait_time = Enemy_dict["delay"]
		Enemy_character.global_position = Vector2(2000,Enemy_positions.pick_random())
		add_child(Enemy_character)
		Enemy_character.GoblinDied.connect(Callable(self,"Create_Drop"))
