extends HBoxContainer
@export var nameCSV :String = "fallo cambio de nombre"
@export var data_BD: Array = []
@export var fusion : bool = false
@onready var NameDB: Label = $Nombre_BD
@export var path: String
@export var edit_active: bool = true
@onready var parent_node = get_parent() # Referencia al nodo padre

func _ready() -> void:
	NameDB.text = str(nameCSV)
	data_BD.remove_at(0)

func get_data() -> Array:
	return data_BD

func set_data(new_data: Array):
	data_BD = new_data
	NameDB.text = str(nameCSV)
	
func saveData(data_to_save: Array) -> void:
	if $Blink.visible:
		CsvCtrl.setup(path, CsvCtrl.ENCABEZADOS_MATRICULA)
		CsvCtrl.data = data_to_save # ¡Aquí pasamos el array completo, con los encabezados!
		CsvCtrl._save_to_file()
		CsvCtrl.data = []
		print("Base de datos '", nameCSV, "' guardada automáticamente.")
		data_BD = data_to_save
	
func delet_grup():
	queue_free()

func _on_borrar_pressed() -> void:
	$Alert.visible = true

func _on_alert_confirmed() -> void:
	queue_free()

func _on_fusion_toggled(toggled_on: bool) -> void:
	fusion = toggled_on

func _on_editar_toggled(toggled_on: bool) -> void:
	edit_active = toggled_on
	$Blink.visible = toggled_on
	
	if toggled_on:
		var parent_children : Array = parent_node.get_children()
		for child in parent_children:
			if child != self and is_instance_valid(child):
				var sibling_button = child.get_node_or_null("Editar")
				if sibling_button != null and sibling_button.button_pressed:
					sibling_button.button_pressed = false
					sibling_button.disabled = toggled_on

	if $Blink.visible:
		parent_node.clear_Data_student()
		parent_node.load_Data_Student(data_BD)
	else:
		parent_node.clear_Data_student()
