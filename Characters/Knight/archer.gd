extends Knight_Class

var Arrow_Scene : PackedScene = preload("res://Characters/Knight/arrow.tscn")

@onready var marker: Marker2D = $Marker2D

func HurtBox_Exited(area: Area2D) -> void:
	Goblin_Array.erase(area.get_parent())

func HurtBox_Entered(area: Area2D) -> void:
	Goblin_Array.append(area.get_parent())

func OnAttack() -> void:
	if !Goblin_Array.is_empty():
		var Arrow : Node2D = Arrow_Scene.instantiate()
		Arrow.position = marker.position
		Arrow.Attack = Attack
		call_deferred("add_child",Arrow)

func Stats_Setter() -> void:
	Cost = 75
	Character_value = 3
	match Global.Difficulty:
		"Easy":
			Health = 80
			Attack = 20
			Attack_Speed = 0.8
		"Medium":
			Health = 80
			Attack = 18
			Attack_Speed = 0.9
		"Hard":
			Health = 75
			Attack = 16
			Attack_Speed = 1
