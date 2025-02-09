extends Knight_Class

var Arrow_Scene : PackedScene = preload("res://Characters/Knight/arrow.tscn")

@onready var marker: Marker2D = $Marker2D

func Enemy_Has_Died() -> void:
	canAttack = false

func HurtBox_Entered(area: Area2D) -> void:
	canAttack = true
	area.get_parent().GoblinDied.connect(Callable(self,"Enemy_Has_Died"))

func OnAttack() -> void:
	var Arrow : Node2D = Arrow_Scene.instantiate()
	Arrow.position = marker.position
	Arrow.Attack = Attack
	add_child(Arrow)
