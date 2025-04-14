extends Knight_Class

@onready var Images: Sprite2D = $Sprite2D

func Stats_Setter() -> void:
	Health = 75
	Attack = 0
	Attack_Speed = 0
	Cost = 75
	Character_value = 3

func Game_Loop() -> void :
	pass

func _ready() -> void:
	Stats_Setter()
	await get_tree().create_timer(5).timeout
	Global.Add_Money.emit(200)
	Images.texture = preload("res://Assets/Resources/Gold Mine/GoldMine_Inactive.png")

func Take_Damage_from_Goblin(Power : float) -> void:
	Health -= Power
	if Health <= 0:
		HitBox_CollisionShape.disabled = true
		KnightDied.emit()
		call_deferred("queue_free")
