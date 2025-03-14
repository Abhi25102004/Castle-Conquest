extends TextureButton

var Amount : int = 0

func _ready() -> void:
	await get_tree().create_timer(10).timeout
	call_deferred("queue_free")

func On_Button_Pressed() -> void:
	Global.Add_Money.emit(Amount)
	call_deferred("queue_free")
