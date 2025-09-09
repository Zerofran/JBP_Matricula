extends HBoxContainer

@export var data_BD: Array = []
@onready var nombre_DB: Label = $Nombre_BD
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_data()->Array:
	return data_BD

func set_data(new_data: Array):
	data_BD = new_data
	nombre_DB.text = str(data_BD)
	
func delet_grup():
	queue_free()
	pass

func _on_borrar_pressed() -> void:
	$Alert.visible = true


func _on_alert_confirmed() -> void:
	queue_free()
