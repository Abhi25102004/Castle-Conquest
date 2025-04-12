extends Knight_Class  # Inherits from your custom Knight base class

# Preload the Arrow scene which will be instantiated during attacks
var Arrow_Scene : PackedScene = preload("res://Characters/Knight/arrow.tscn")

# Dictionary to hold textures for different faction tower appearances
var Image_Dict : Dictionary = {
	"Blue" : preload("res://Assets/Factions/Knights/Buildings/Tower/Tower_Blue.png"),
	"Red" : preload("res://Assets/Factions/Knights/Buildings/Tower/Tower_Red.png"),
	"Yellow" : preload("res://Assets/Factions/Knights/Buildings/Tower/Tower_Yellow.png"),
	"Purple" : preload("res://Assets/Factions/Knights/Buildings/Tower/Tower_Purple.png")
}

# Node references initialized when the scene is ready
@onready var marker: Marker2D = $Marker2D           # Arrow will be fired from this point
@onready var picutre : Sprite2D = $Sprite2D          # Used to show the correct tower sprite

# When a Goblin leaves the tower's HurtBox area, remove it from the array
func HurtBox_Exited(area: Area2D) -> void:
	Goblin_Array.erase(area.get_parent())  # Ensure goblin is removed from the tracked array

# When a Goblin enters the tower's HurtBox area, add it to the array
func HurtBox_Entered(area: Area2D) -> void:
	Goblin_Array.append(area.get_parent()) # Track goblin to potentially shoot it

# Handles the attack behavior by spawning and shooting an arrow at the first goblin
func OnAttack() -> void:
	if !Goblin_Array.is_empty():
		var Goblin : Goblin_Class = Goblin_Array[0]  # Get the first goblin in range
		var Arrow : Node2D = Arrow_Scene.instantiate()  # Create a new arrow instance
		Arrow.position = marker.position                 # Start from the marker position
		Arrow.Attack = Attack                            # Set arrow's attack damage
		Arrow.rotation = marker.global_position.angle_to_point(Goblin.global_position)  # Set direction visually
		Arrow.Direction = (Goblin.global_position - marker.global_position).normalized() # Set movement vector
		call_deferred("add_child",Arrow)                # Add arrow to the scene safely

# Sets the stats for this tower unit
func Stats_Setter() -> void:
	Health = 150                             # High durability
	Attack = 30                              # Moderate damage
	Attack_Speed = randf_range(0.7, 0.9)     # Randomized attack interval for variety
	Cost = 75                                # Coin cost to place this unit
	Character_value = 5                      # Used to identify or categorize this unit

# Initialization on scene ready
func _ready() -> void:
	picutre.texture = Image_Dict.get(Global.Theme_color)  # Set tower sprite based on global faction theme
	Stats_Setter()                                        # Initialize stats
	HurtBox.area_entered.connect(HurtBox_Entered)         # Connect goblin detection signals
	HurtBox.area_exited.connect(HurtBox_Exited)
