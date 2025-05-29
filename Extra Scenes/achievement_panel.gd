extends PanelContainer

@onready var achievement_name: Label = $VBoxContainer/Achievement_name
@onready var achievement_description: Label = $VBoxContainer/Achievement_description
@onready var completed: Label = $Completed

@export var name_ : String
@export var description : String
@export var completed_ : bool

func Set_Values() -> void:
	achievement_name.text = name_
	achievement_description.text = description
	completed.visible = completed_

func _ready() -> void:
	Set_Values()
