extends Resource

class_name Settings_Save

@export var Sound_Controller : Dictionary[String,float] = {
	"Master" : 1,
	"Music" : 1,
	"Sound effects" : 1
	}
	
@export var Game_Mode : String = "Easy"

@export var Player_Colour : String = "Blue"

@export var Scree_Size : String = ""

@export var continue_available : bool = false
