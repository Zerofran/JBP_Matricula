extends HBoxContainer

@onready var estudiante_instance: VBoxContainer = $"../BD_Estudiantes/BD_Container/estudiante_instance"
@onready var numero_estudiante: Label = $num_estudiante
@onready var barra_busqueda: LineEdit = $barra_busqueda

var estudiantes_visibles_count = 0

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	estudiantes_visibles_count = 0
	for child in estudiante_instance.get_children():
		if is_instance_valid(child) and child.visible:
			estudiantes_visibles_count += 1
	numero_estudiante.text = str(estudiantes_visibles_count)


func _on_barra_busqueda_text_changed(new_text: String) -> void:
	var lista = estudiante_instance.get_children()
	for i in lista.size():
		if (str(lista[i].nombre_nodo).to_lower()).similarity(new_text.to_lower()) > 0.25 :
			lista[i].visible = true
		else:
			lista[i].visible = false
	if new_text == "":
		for i in lista.size():
			lista[i].visible = true
