extends CanvasLayer

signal Create_Knight

var player_character : String
var money : int = 100

@onready var Money_lable: Label = $"Game Context/Label2"

func _on_button_pressed() -> void:
	Create_Knight.emit("pawn")
	player_character = "pawn"

func _on_button_2_pressed() -> void:
	Create_Knight.emit("warrior")
	player_character = "warrior"

func _on_placement_has_been_created(diff : int) -> void:
	money = (money-diff) if money > 0 else 0
	Money_lable.text = "Money: " + str(money)
