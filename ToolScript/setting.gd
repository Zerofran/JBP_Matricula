extends Control

@onready var foto : TextureRect = $"../ScrollContainer/HBoxContainer/PrincipalContainer_V/Encavezado/Foto_Estudiante"

func _ready() -> void:
	visible = true
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("tap"):
		self.visible =! self.visible


func _on_foto_pressed() -> void:
	$"../FileDialog".visible = true


func _on_file_dialog_file_selected(path: String) -> void:
	pass # Replace with function body.
