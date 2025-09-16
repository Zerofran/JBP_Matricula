extends Control

# Nodos de los campos del formulario
@onready var codigo : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_estudiante/procedencia/codigo_estudiante
@onready var nombreEstudinte : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_estudiante/Nombre/NombreApellido
@onready var lugarNacimiento : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_estudiante/informacion_natal/lugar_nacimiento
@onready var edad : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_estudiante/informacion_natal/edad
@onready var sexo : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_estudiante/informacion_natal/sexo
@onready var direcccion : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_estudiante/direccion/direccion_actual
@onready var direcccion_add: LineEdit
@onready var gradoAprobado : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_estudiante/curso/g_aprobado
@onready var gradoPorCursar : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_estudiante/curso/g_cursado
@onready var repitente : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_estudiante/curso/repitente
@onready var centroProcedencia : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_estudiante/procedencia/procedencia
@onready var nombrePadre : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_padre/Nombre/nombre_padre/nombre_padre
@onready var cedulaPadre : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_padre/Nombre/cedula_padre/cedula_padre
@onready var celularPadre : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_padre/Nombre/celular/celular_padre
@onready var correoPadre : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_del_padre/Correo/correo_padre
@onready var nombreMadre : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_de_la_madre/Nombre/nombre_madre/nombre_madre
@onready var cedulaMadre : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_de_la_madre/Nombre/cedula_madre/cedula_madre
@onready var celularMadre : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_de_la_madre/Nombre/celular/celular_madre
@onready var correoMadre : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/datos_de_la_madre/Correo/correo_madre
@onready var nombreTutor : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/d_tutor/Nombre/nombre_tutor/nombre_madre
@onready var cedulaTutor : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/d_tutor/Nombre/cedula_tutor/cedula_tutor
@onready var celularTutor : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/d_tutor/Nombre/celular/celular_tutor
@onready var correoTutor : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/d_tutor/Correo/correo_tutor
@onready var partidaNacimiento : LineEdit = $"ScrollContainer/HBoxContainer/PrincipalContainer_V/Documentos entregados/GridContainer/Doc1"
@onready var notaAnterior : LineEdit = $"ScrollContainer/HBoxContainer/PrincipalContainer_V/Documentos entregados/GridContainer/Doc2"
@onready var hojaTraslado : LineEdit = $"ScrollContainer/HBoxContainer/PrincipalContainer_V/Documentos entregados/GridContainer/Doc3"
@onready var copiaDiploma : LineEdit = $"ScrollContainer/HBoxContainer/PrincipalContainer_V/Documentos entregados/GridContainer/Doc4"
@onready var copiaCedula_FamiliarTutor : LineEdit = $"ScrollContainer/HBoxContainer/PrincipalContainer_V/Documentos entregados/GridContainer/Doc5"
@onready var fechaMatricula : LineEdit = $"ScrollContainer/HBoxContainer/PrincipalContainer_V/Documentos entregados/GridContainer/Doc6"
@onready var firma : Control = $ScrollContainer/HBoxContainer/PrincipalContainer_V/FirmaTutor/FirmaContainer/FirmaControl
@onready var nombreGestor : LineEdit = $ScrollContainer/HBoxContainer/PrincipalContainer_V/n_gestor/cedula_madre2/nombre_madre

# Campo de foto y imagen por defecto
@onready var fotoStudiante : TextureRect = $ScrollContainer/HBoxContainer/PrincipalContainer_V/Encavezado/Foto_Estudiante
var defaul_img = load("res://IMG/DefaulPerfil_Image.png")

# Array para simplificar el acceso a los LineEdit
@onready var line_edit_nodes: Array = [
	codigo, nombreEstudinte, lugarNacimiento, edad, sexo, direcccion,
	gradoAprobado, gradoPorCursar, repitente, centroProcedencia,
	nombrePadre, cedulaPadre, celularPadre, correoPadre,
	nombreMadre, cedulaMadre, celularMadre, correoMadre,
	nombreTutor, cedulaTutor, celularTutor, correoTutor,
	partidaNacimiento, notaAnterior, hojaTraslado, copiaDiploma,
	copiaCedula_FamiliarTutor, fechaMatricula, nombreGestor
]

func get_form() -> Array:
	var data_array = []
	
	# Recolecta los datos de los LineEdit en el orden de los encabezados.
	data_array.append(codigo.text)
	data_array.append(nombreEstudinte.text)
	data_array.append(lugarNacimiento.text)
	data_array.append(edad.text)
	data_array.append(sexo.text)
	data_array.append(direcccion.text)
	data_array.append(gradoAprobado.text)
	data_array.append(gradoPorCursar.text)
	data_array.append(repitente.text)
	data_array.append(centroProcedencia.text)
	data_array.append(nombrePadre.text)
	data_array.append(cedulaPadre.text)
	data_array.append(celularPadre.text)
	data_array.append(correoPadre.text)
	data_array.append(nombreMadre.text)
	data_array.append(cedulaMadre.text)
	data_array.append(celularMadre.text)
	data_array.append(correoMadre.text)
	data_array.append(nombreTutor.text)
	data_array.append(cedulaTutor.text)
	data_array.append(celularTutor.text)
	data_array.append(correoTutor.text)
	data_array.append(partidaNacimiento.text)
	data_array.append(notaAnterior.text)
	data_array.append(hojaTraslado.text)
	data_array.append(copiaDiploma.text)
	data_array.append(copiaCedula_FamiliarTutor.text)
	data_array.append(fechaMatricula.text)
	
	# Obtiene la cadena de la firma directamente de FirmaScript.gd
	var firma_data: Array = firma.get_puntos_firma()
	data_array.append(firma_data)
	
	data_array.append(nombreGestor.text)
	data_array.append(CsvCtrl.texture_to_base64(fotoStudiante.texture))
	
	return data_array

func set_form(data_array: Array) -> void:
	if data_array.size() != 31:
		print("Error: El array de datos no coincide con el número de campos del formulario.")
		return

	# Asigna los datos a los LineEdit en el orden correcto.
	codigo.text = data_array[0]
	nombreEstudinte.text = data_array[1]
	lugarNacimiento.text = data_array[2]
	edad.text = data_array[3]
	sexo.text = data_array[4]
	direcccion.text = data_array[5]
	gradoAprobado.text = data_array[6]
	gradoPorCursar.text = data_array[7]
	repitente.text = data_array[8]
	centroProcedencia.text = data_array[9]
	nombrePadre.text = data_array[10]
	cedulaPadre.text = data_array[11]
	celularPadre.text = data_array[12]
	correoPadre.text = data_array[13]
	nombreMadre.text = data_array[14]
	cedulaMadre.text = data_array[15]
	celularMadre.text = data_array[16]
	correoMadre.text = data_array[17]
	nombreTutor.text = data_array[18]
	cedulaTutor.text = data_array[19]
	celularTutor.text = data_array[20]
	correoTutor.text = data_array[21]
	partidaNacimiento.text = data_array[22]
	notaAnterior.text = data_array[23]
	hojaTraslado.text = data_array[24]
	copiaDiploma.text = data_array[25]
	copiaCedula_FamiliarTutor.text = data_array[26]
	fechaMatricula.text = data_array[27]
	
	# Carga la firma
	firma.dibujar_firma(data_array[28])
	
	nombreGestor.text = data_array[29]
	
	var imagen_base64: String = data_array[30]
	var nueva_textura: Texture2D = CsvCtrl.base64_to_texture(imagen_base64)
	fotoStudiante.texture = nueva_textura

func clear_form() -> void:
	for node in line_edit_nodes:
		node.text = ""
	# Llama a la nueva funcion para limpiar la firma.
	if is_instance_valid(firma):
		firma.clear_firma()
	fotoStudiante.texture = defaul_img


func _on_limpiar_pressed() -> void:
	clear_form()


func _on_guardar_pressed() -> void:
	var estudiante_instance = $Setting/PrincipalContainer/DataBaseContainer/BD_Estudiantes/BD_Container/estudiante_instance
	for child in estudiante_instance.get_children():
		if child.get_node("Blink").visible:
			child.set_data(get_form())
	$Setting.visible = true
