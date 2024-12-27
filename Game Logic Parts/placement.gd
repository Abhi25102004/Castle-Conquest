extends Node2D

@export var Positions_X : Array[float]
@export var Positions_Y : Array[float]
@export var Warrior : PackedScene
@export var Torch : PackedScene

var canAdd : bool = true
var Vector_Array : Array[Vector2] = []
var Enemy_Array : Array[Vector2] = []

var CharacterCount : Vector2 = Vector2i.ZERO

func _ready() -> void:
	for x in Positions_X:
			for y in Positions_Y:
				Vector_Array.append(Vector2(x,y))
	
	for y in Positions_Y:
		Enemy_Array.append(Vector2(1066.66,y))

func _process(_delta: float) -> void:
	if canAdd and CharacterCount.y < 10:
		canAdd = !canAdd
		Add_Enemy()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("MouseClick") and CharacterCount.x < 10 :
		var Size_Array : Array[float] = []
		for vector in Vector_Array:
			Size_Array.append(get_global_mouse_position().distance_squared_to(vector))
		var Kight : Node2D = Warrior.instantiate()
		Kight.global_position = Vector_Array[Size_Array.find(Size_Array.min())]
		Kight.KnightDied.connect(Callable(self,"PlayerCounter"))
		add_child(Kight)
		CharacterCount.x += 1

func Add_Enemy() -> void:
	await get_tree().create_timer(randf()*5).timeout
	var Enemy : Node2D = Torch.instantiate()
	Enemy.global_position = Enemy_Array.pick_random()
	Enemy.GoblinDied.connect(Callable(self,"EnemyCounter"))
	add_child(Enemy)
	CharacterCount.y += 1
	canAdd = !canAdd

func PlayerCounter() -> void:
	CharacterCount.x -=1

func EnemyCounter() -> void:
	CharacterCount.y -= 1
	
