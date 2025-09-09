extends HBoxContainer

@export var data_estudiante: Array = []
@onready var nombre_DB : Label = $Nombre_Estudiante

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_data()->Array:
	return data_estudiante

func set_data(new_data: Array):
	data_estudiante = new_data
	nombre_DB.text = str(data_estudiante[1])


func _on_borrar_pressed() -> void:
	queue_free()
