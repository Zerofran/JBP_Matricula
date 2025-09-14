extends VBoxContainer
@onready var InstanceStudent: VBoxContainer = $"../../../BD_Estudiantes/BD_Container/estudiante_instance"
var estudiante_scene: PackedScene = load("res://Escenas/estudiante.tscn")

# Se usa un array para almacenar las instancias de los estudiantes.
var student_instances: Array = []
# Variable para guardar la referencia a la base de datos activa
var active_database: Array = []

func _ready() -> void:
	# El código de limpieza en _ready() es un buen hábito.
	for child in get_children():
		child.queue_free()

# Carga y muestra los datos de los estudiantes.
func load_Data_Student(students_data: Array) -> void:
	print(students_data)
	# Limpia las instancias existentes para evitar duplicados.
	for child in InstanceStudent.get_children():
		child.queue_free()
	
	# Itera sobre los datos usando un índice para saber la posición de cada estudiante.
	for i in range(1, students_data.size()):
		var student = students_data[i]
		
		# Ignora el primer elemento si es un encabezado.
		if i == 0:
			continue
			
		var new_student = estudiante_scene.instantiate()
		
		# Llena las variables export de la escena instanciada.
		new_student.data_estudiante = student
		new_student.index_BD = i # Aquí se asigna el índice correcto del array.
		
		InstanceStudent.add_child(new_student)
		print(student, " verifiquemos")

func clear_Data_student():
	for child in InstanceStudent.get_children():
		child.queue_free()
