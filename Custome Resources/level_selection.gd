extends Resource

class_name Level_Selection

@export var Current_Level: int = 1
@export var level_Played : Array[int] = []
@export var Available_Buttons: Array[String] = ["Pawn"]
@export var Game_Difficulty : String = "Easy"
@export var Color_String : String = "Blue"
@export var Difficulty_played : Dictionary[String,Array] = {
	"Easy" : [],
	"Medium" : [],
	"Hard" : [],
}
@export var Audio : Dictionary[String,float] = {
	"Master" : 1,
	"Music" : 1,
	"Sound effects" : 1
	}
