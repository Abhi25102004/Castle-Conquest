extends Knight_Class

var Arrow_Scene : PackedScene = preload("res://Characters/Knight/arrow.tscn")

@onready var marker: Marker2D = $Marker2D
var Area : Area2D = null

func HurtBox_Exited(_area: Area2D) -> void:
	canAttack = false

func HurtBox_Entered(_area: Area2D) -> void:
	canAttack = true

func OnAttack() -> void:
	var Arrow : Node2D = Arrow_Scene.instantiate()
	Arrow.position = marker.position
	Arrow.Attack = Attack
	add_child(Arrow)
