extends Area2D

signal Update_Priority

var Current_Characters : Array[Node2D]
var Total_value : float
@onready var timer: Timer = $Timer

func Area_Entered(area: Area2D) -> void:
	Current_Characters.append(area.get_parent())

func Area_Exited(area: Area2D) -> void:
	Current_Characters.erase(area.get_parent())

func Timeout() -> void:
	Total_value = 0
	for character in Current_Characters:
		Total_value += character.Health
	Update_Priority.emit(Total_value)
