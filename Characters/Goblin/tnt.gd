extends Goblin_Class

var Dynamite : PackedScene = preload("res://Characters/Goblin/dynamite.tscn")

@onready var marker: Marker2D = $Marker2D

func HurtBox_Entered(_area: Area2D) -> void:
	canAttack = true

func HurtBox_Exited(_area: Area2D) -> void:
	canAttack = false
	
func OnAttack() -> void:
	var Dynamite_instance : Node2D = Dynamite.instantiate()
	Dynamite_instance.Attack = Attack
	Dynamite_instance.position = marker.position
	add_child(Dynamite_instance)
