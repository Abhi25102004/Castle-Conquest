extends Resource

class_name Level_Information

@export var Level_number : int
@export var Money_Required : int
@export var Wave1 : Wave
@export var Wave2 : Wave
@export var Wave3 : Wave
@export var Reward : String = ""
@export var Game_Total_Enemies : int = 0
@export var Level_Scene : PackedScene = preload("res://Map/level_1.tscn")
