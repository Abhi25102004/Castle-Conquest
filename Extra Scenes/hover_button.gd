extends Button

@onready var marker: Marker2D = $Marker2D

@export var isFree : bool = true

func Add_Scene(character_scene : PackedScene) -> void:
	Remove_child()
	Add(character_scene)

func Remove_child() -> void:
	if !isFree:
		Remove()

func Add(character_scene : PackedScene) -> void:
	var character : Node2D = character_scene.instantiate()
	character.position = marker.position
	add_child(character)
	isFree = false
	character.KnightDied.connect(func(): isFree = true)

func Remove() -> void:
	if get_child_count() == 2 and get_child(1) is Node2D:
		Global.Add_Money.emit(int(get_child(1).Cost / 20) * 10)
		get_child(1).call_deferred("queue_free")
