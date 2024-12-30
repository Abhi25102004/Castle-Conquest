extends Control

signal Type_Of_Knight

@export var pawn : PackedScene
@export var warrior : PackedScene

@export var Money_box : Label
@export var Killed_box : Label

var money : int = 100
var killed : int = 0

func _on_pawn_pressed() -> void:
	if money > 0:
		Type_Of_Knight.emit(pawn)

func _on_warrior_pressed() -> void:
	if money > 0:
		Type_Of_Knight.emit(warrior)

func _on_placement_change_lable(amount : int) -> void:
	money += amount
	killed += 1 if amount > 0 else 0
	Money_box.text = "Money : " + str(money)
	Killed_box.text = "Enemy Killed : " + str(killed)
