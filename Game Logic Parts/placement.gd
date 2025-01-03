extends Node2D

signal HasBeenCreated

@onready var Row_container: Node2D = $"Row Container"
@onready var timer: Timer = $Timer
@onready var Knight : Node2D = get_parent().get_child(2)
@onready var enemy_spawner: Node2D = $"Enemy Spawner"

var canAdd = true
var Placement_marker : Marker2D = null
var character : String

@export var Character_information: Dictionary = {}
@export var Torch : Array[PackedScene] = []

func _on_timer_timeout() -> void:
	timer.start()
	if Placement_marker != null:
		Placement_marker.Disable_Selection()
	var Minimum_value : float = pow(9999,2)
	for row in Row_container.get_children():
		for marker in row.get_children():
			if Minimum_value > marker.Check_Distance():
				Minimum_value = marker.Check_Distance()
				Placement_marker = marker
	Placement_marker.Enable_Selection()

func _on_game_user_interface_create_knight(Character : String) -> void:
	timer.start()
	character = Character
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("MouseClick") and Placement_marker:
		if Placement_marker.Reserved:
			for knights in Knight.get_children():
				if knights.global_position == Placement_marker.global_position:
					knights.queue_free()
					Placement_marker.Reserved = false
					break
		else:
			Placement_marker.Reserved = true
			var node : Node2D = Character_information[character.to_lower()].instantiate()
			node.global_position = Placement_marker.global_position
			Knight.add_child(node)
			HasBeenCreated.emit(30 if character == "pawn" else 75)
			
		timer.stop()
		Placement_marker.Disable_Selection()
		Placement_marker = null
	
	if canAdd:
		canAdd = !canAdd
		Add_enemy()

func Add_enemy() -> void:
	await get_tree().create_timer(randf()*10).timeout
	var Enemy : Node2D = Torch.pick_random().instantiate()
	Enemy.global_position = enemy_spawner.get_children().pick_random().global_position
	Enemy.GoblinDied.connect(Callable(self,"EnemyCounter"))
	add_child(Enemy)
	canAdd = !canAdd
