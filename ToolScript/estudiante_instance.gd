extends VBoxContainer

@export var estudiante_scene: PackedScene = preload("res://Escenas/estudiante.tscn")
@onready var estudiantes_container: VBoxContainer = self
@onready var formulario_de_matricula = $"../../../../../.."
@onready var BD_instance: VBoxContainer = $"../../../BD_Disponibles/BD_Container/DataBaseInstance"
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var option = $"../../../Option"
	get_activeBD()
	if get_children().size() == 0:
		for child in option.get_children():
			child.disabled = true
	else:
		for child in option.get_children():
			child.disabled = false

func _on_añadir_pressed() -> void:
	var index = 0
	var data_estudiante = CsvCtrl.DATOS_POR_DEFECTO
	formulario_de_matricula.clear_form()
	for child in BD_instance.get_children():
		if child.get_node("Blink").visible:
			index = child.data_BD.size()
			child.data_BD.append(data_estudiante)
			child.saveData(child.data_BD)
	var estudiante = estudiante_scene.instantiate()
	estudiante.data_estudiante = data_estudiante
	estudiante.index_BD = index+1
	add_child(estudiante)

func _on_borrar_pressed() -> void:
	for child in get_children():
		if child.delet:
			child.queue_free()
	#funciona

func _on_organizar_pressed() -> void:
	var students_data: Array = []
	for child in estudiantes_container.get_children():
		if is_instance_valid(child) and child is HBoxContainer:
			students_data.append(child.get_data())
	
	students_data.sort_custom(func(a, b): return a[1] < b[1])
	
	for child in estudiantes_container.get_children():
		if is_instance_valid(child):
			child.queue_free()

	for i in range(students_data.size()):
		var new_student = estudiante_scene.instantiate()
		estudiantes_container.add_child(new_student)
		new_student.set_data(students_data[i], i)
		new_student.connect("editar_estudiante", Callable(self, "_on_editar_estudiante_signal"))
		new_student.connect("borrar_estudiante", Callable(self, "_on_borrar_estudiante_signal"))
	
	print("Estudiantes organizados alfabéticamente.")

func _on_guardar_pressed() -> void:
	var DataStudent: Array = []
	for db_node in BD_instance.get_children():
		if db_node.get_node("Blink").visible:
			print(db_node.nameCSV, "   esta es la base de datos ")
			for student_node in get_children():
				DataStudent.append(student_node.data_estudiante)
		db_node.saveData(DataStudent)

func get_activeBD():
	# 1. Primera pasada: Determina si existe alguna base de datos en modo de edición.
	var any_db_is_active = false
	for db_node in BD_instance.get_children():
		# Se verifica si el nodo `Blink` es visible.
		if db_node.get_node("Blink").visible:
			any_db_is_active = true
			break # Si se encuentra una, no es necesario seguir buscando.

	# 2. Segunda pasada: Desactiva o activa los botones de forma global.
	for db_node in BD_instance.get_children():
		var edit_button = db_node.get_node("Editar")
		var blink_node = db_node.get_node("Blink")

		# Si hay una base de datos activa, desactiva el botón de 'Editar' en todos
		# los demás nodos. Si no, activa el botón de 'Editar' en todos.
		if any_db_is_active:
			if not blink_node.visible:
				edit_button.disabled = true
		else:
			edit_button.disabled = false

func editStudent(data:Array):
	if data[0] == "New":
		formulario_de_matricula.clear_form()
	else:
		formulario_de_matricula.set_form(data)
	$"../../../../..".visible = false
