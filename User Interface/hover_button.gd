extends Button

@onready var marker: Marker2D = $Marker2D

@export var Scene : PackedScene = null
@export var placed : bool = false

func Add_Scene() -> void :
	var character : Node2D = Scene.instantiate()
	character.position = marker.position
	add_child(character)
	character.KnightDied.connect(Callable(self,"Set_Position_free"))

func Remove_Scene() -> int:
	var money : int = 0
	if get_child_count() == 2:
		money = get_child(1).Cost
		get_child(1).queue_free()
	return money

func Set_Position_free() -> void:
	placed = false
