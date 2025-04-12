extends Knight_Class

# Onready reference to the visual node
@onready var Images: Sprite2D = $Sprite2D

# Sets the stats for the Gold Mine
func Stats_Setter() -> void:
	Health = 75              # HP of the mine (could be damaged by goblins if desired)
	Attack = 0               # No attack power
	Attack_Speed = 0         # Doesn't attack
	Cost = 75                # Cost to place the gold mine
	Character_value = 3      # Any internal identifier (optional)

# Overrides the Knight's Game_Loop so it doesn't attack or animate like a Knight
func Game_Loop() -> void :
	pass

# Called when the node is added to the scene
func _ready() -> void:
	Stats_Setter()
	await get_tree().create_timer(5).timeout  # Wait for 5 seconds
	Global.Add_Money.emit(200)               # Add 200 coins to the player
	Images.texture = preload("res://Assets/Resources/Gold Mine/GoldMine_Inactive.png")
	# Update the sprite to show it's now inactive (used/given gold)

func Take_Damage_from_Goblin(Power : float) -> void:
	Health -= Power
	if Health <= 0:
		HitBox_CollisionShape.disabled = true
		# Emit signal to notify others of death
		KnightDied.emit()
		call_deferred("queue_free") # Remove from scene safely
