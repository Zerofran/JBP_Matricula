extends Control

func _ready() -> void:
	visible = true
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("tap"):
		self.visible =! self.visible
