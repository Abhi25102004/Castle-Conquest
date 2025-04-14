extends Knight_Class


var Arrow_Scene : PackedScene = preload("res://Characters/Knight/arrow.tscn")

var Image_Dict : Dictionary = {
	"Blue" : preload("res://Assets/Factions/Knights/Buildings/Tower/Tower_Blue.png"),
	"Red" : preload("res://Assets/Factions/Knights/Buildings/Tower/Tower_Red.png"),
	"Yellow" : preload("res://Assets/Factions/Knights/Buildings/Tower/Tower_Yellow.png"),
	"Purple" : preload("res://Assets/Factions/Knights/Buildings/Tower/Tower_Purple.png")
}

@onready var marker: Marker2D = $Marker2D
@onready var picutre : Sprite2D = $Sprite2D

func HurtBox_Exited(area: Area2D) -> void:
	Goblin_Array.erase(area.get_parent())

func HurtBox_Entered(area: Area2D) -> void:
	Goblin_Array.append(area.get_parent())

func OnAttack() -> void:
	if !Goblin_Array.is_empty():
		var Goblin : Goblin_Class = Goblin_Array[0]
		var Arrow : Node2D = Arrow_Scene.instantiate()
		Arrow.position = marker.position
		Arrow.Attack = Attack
		Arrow.rotation = marker.global_position.angle_to_point(Goblin.global_position)
		Arrow.Direction = (Goblin.global_position - marker.global_position).normalized()
		call_deferred("add_child",Arrow)

func Stats_Setter() -> void:
	Health = 150
	Attack = 30
	Attack_Speed = randf_range(0.7, 0.9)
	Cost = 75
	Character_value = 5

func _ready() -> void:
	picutre.texture = Image_Dict.get(Global.Theme_color)
	Stats_Setter()
	HurtBox.area_entered.connect(HurtBox_Entered)
	HurtBox.area_exited.connect(HurtBox_Exited)
