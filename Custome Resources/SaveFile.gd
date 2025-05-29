extends Resource

class_name SaveFile

@export var level_Played : Array[int] = []

@export var Available_Buttons: Array[String] = ["Pawn"]

@export var Difficulty_played : Dictionary[String,Array] = {
	"Easy" : [],
	"Medium" : [],
	"Hard" : [],
}

@export var Endless_High_Score : int = 0
