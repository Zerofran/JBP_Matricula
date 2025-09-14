extends HBoxContainer

# Las variables de este nodo
@export var data_estudiante: Array = []
@export var index_BD: int = -1 # Guarda el índice del estudiante en la base de datos
@export var edit_active: bool = false # Estado del modo de edición
@export var delet: bool = false

# Referencias a los nodos de la interfaz
@onready var nombre_estudiante : Label = $Nombre_Estudiante

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	nombre_estudiante.text = str(data_estudiante[1])

## Obtiene los datos del estudiante
func get_data() -> Array:
	return data_estudiante

## Asigna los datos y el índice al estudiante
func set_data(new_data: Array):
	if new_data.size() > 1:
		data_estudiante = new_data
		nombre_estudiante.text = str(data_estudiante[1])
	else:
		print("Error: Los datos del estudiante están incompletos.")

## Borra el nodo al presionar el botón
func _on_borrar_pressed() -> void:
	$AcceptDialog.visible = true
func _on_accept_dialog_confirmed() -> void:
	queue_free()
	

## Maneja la activación y desactivación del modo de edición
func _on_editar_toggled(toggled_on: bool) -> void:
	edit_active = toggled_on
	$Blink.visible = toggled_on
	if toggled_on:
		var parent_node = get_parent()
		var sibling_nodes = parent_node.get_children()
		for child in sibling_nodes:
			if child != self and is_instance_valid(child):
				var sibling_button = child.get_node_or_null("Editar")
				if sibling_button != null and sibling_button.button_pressed:
					sibling_button.button_pressed = false
					
	if $Blink.visible:
		get_parent().editStudent(data_estudiante)

func _on_borrar_seleccionado_toggled(toggled_on: bool) -> void:
	delet = toggled_on
