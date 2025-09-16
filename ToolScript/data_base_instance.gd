extends VBoxContainer
@onready var InstanceStudent: VBoxContainer = $"../../../BD_Estudiantes/BD_Container/estudiante_instance"
var estudiante_scene: PackedScene = load("res://Escenas/estudiante.tscn")

# Se usa un array para almacenar las instancias de los estudiantes.
var student_instances: Array = []
# Variable para guardar la referencia a la base de datos activa
var active_database: Array = []

var children

func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	children = get_children().size()
	if children == 0:
		for i in $"../../../Export".get_children():
			i.disabled = true
	else:
		for i in $"../../../Export".get_children():
			i.disabled = false
	

func load_Data_Student(students_data: Array) -> void:
	var start_index = 0
	if students_data.size() > 0 and Array(students_data[0]) == CsvCtrl.ENCABEZADOS_MATRICULA:
		start_index = 1
		print("Se ha detectado una fila de encabezados, se omite.")

	for i in range(start_index, students_data.size()):
		var student = Array(students_data[i]) # aseguramos que sea Array normal

		# Conversión de la firma si es String en formato Godot
		if student.size() > 28 and student[28] is String and student[28].begins_with("["):
			var parsed = str_to_var(student[28])
			if typeof(parsed) == TYPE_ARRAY:
				var firma_array = []
				for trazo in parsed:
					var packed = PackedVector2Array()
					for punto in trazo:
						if punto is Vector2:
							packed.append(punto)
						elif punto is Array and punto.size() >= 2:
							packed.append(Vector2(punto[0], punto[1]))
					firma_array.append(packed)
				student[28] = firma_array


		var new_student = estudiante_scene.instantiate()
		new_student.data_estudiante = student
		new_student.index_BD = i 
		InstanceStudent.add_child(new_student)
		print("Instancia exitosa")


func clear_Data_student():
	for child in InstanceStudent.get_children():
		child.queue_free()
