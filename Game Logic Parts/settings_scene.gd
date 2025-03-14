extends CanvasLayer

@onready var Animations: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	%Blue.pressed.connect(func(): Global.Theme_color = "Blue")
	%Red.pressed.connect(func(): Global.Theme_color = "Red")
	%Yellow.pressed.connect(func(): Global.Theme_color = "Yellow")
	#%Purple.pressed.connect(func(): Global.Theme_color = "Purple")
	
	%Easy.pressed.connect(func(): Global.Difficulty = 0.5)
	%Medium.pressed.connect(func(): Global.Difficulty = 1)
	%Hard.pressed.connect(func(): Global.Difficulty = 2)
	
	%Quit.pressed.connect(func(): 
		Animations.play_backwards("Entry")
		await Animations.animation_finished
		call_deferred("Change_Scene"))

func Change_Scene() -> void:
	get_tree().change_scene_to_file(Global.Setting_Last_Scene)
