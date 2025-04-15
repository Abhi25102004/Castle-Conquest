extends Node

@onready var instruciton_lable: Label = $Control/Label
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var control: Control = $Control

var block_tutorial : bool = false
var Instruction : Array[String] = [
	"Good luck, Commander! Defend your castle and stop the goblin invasion!\n\nClick to begin...",
	"Instruction:\nHover over the grass tiles to choose where to place the selected character.\n\nClick to continue...",
	"Instruction:\nUse the buttons below to select a character. Each character costs a specific amount of coins to deploy.\n\nClick to continue...",
	"Instruction:\nYou can track your goblin kills at the top center of the screen.\n\nClick to continue...",
	"Instruction:\nTry combining different units to create a balanced defense. Mix economy, defense, and offense.\n\nClick to continue...",
	"Instruction:\nYour current coin amount is displayed at the top left. Earn more coins by eliminating goblins.\n\nClick to continue...",
	"Instruction:\nSome characters attack enemies, while others defend or generate coins. Use them wisely.\n\nClick to continue...",
	"Instruction:\nEach level gets progressively harder. Spend your coins wisely and keep upgrading your defense.\n\nClick to continue...",
	"Instruction:\nIf a goblin crosses the bridge, you lose! Keep your lanes secure at all times.\n\nClick to continue...",
	"Instruction:\nThis is a tower defense game. Goblins approach from the right—don't let them cross the bridge!\n\nClick to continue...",
]

func Change_Lable() -> void:
	if !Instruction.is_empty():
		instruciton_lable.text = Instruction.pop_back()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("MouseClick") and !animations.is_playing() and !block_tutorial:
		animations.play()
		await animations.animation_finished
		if !Instruction.is_empty():
			animations.play("Instructions")
		else:
			control.visible = false
			block_tutorial = true
			var Enemy : Goblin_Class = preload("res://Characters/Goblin/torch.tscn").instantiate()
			Enemy.global_position = Vector2(2000, [221, 407, 593, 779].pick_random())
			Enemy.GoblinDied.connect(func():
				control.visible = true
				instruciton_lable.text = "Congratulations!\n\nYou've successfully defended the castle and defeated all incoming goblins!\n\nPrepare yourself — greater challenges await in the next level."
				animations.play("Level Completed")
				await animations.animation_finished
				get_tree().change_scene_to_file("res://Main Game Scenes/level_interface.tscn")
			)
			call_deferred("add_child", Enemy)
