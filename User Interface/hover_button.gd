extends Button

@onready var marker: Marker2D = $Marker2D

@export var Scene : PackedScene = null
@export var placed : bool = false

func Add_Scene() -> void :
	var character : Node2D = Scene.instantiate()
	character.position = marker.position
	add_child(character)
	character.KnightDied.connect(Callable(self,"Set_Position_free"))

func Remove_Scene() -> void:
	if get_child_count() == 2 and get_child(1) is Node2D:
		Global.emit_signal("Add_Money",25)
		get_child(1).call_deferred("queue_free")

func Set_Position_free() -> void:
	placed = false
