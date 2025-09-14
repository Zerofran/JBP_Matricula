extends Control

@onready var foto_Estudiante : TextureRect = $"../ScrollContainer/HBoxContainer/PrincipalContainer_V/Encavezado/Foto_Estudiante"
@onready var Captura: TextureRect = $PrincipalContainer/CapturContainer/captura_matricula
var imagen: Image

#este nodo es usado para instanciar las bases de datos
@onready var DataBaseInstance: VBoxContainer = $PrincipalContainer/DataBaseContainer/BD_Disponibles/BD_Container/DataBaseInstance
var data_base : PackedScene = load("res://Escenas/data_base.tscn") #sera la escena instanciada, a la cual tambien se le pasan los datos leidos del CSV

@onready var saveCaptura = $PrincipalContainer/CapturContainer/saveCaptura
@onready var buttonCapture = $PrincipalContainer/CapturContainer/CaptureButton

func _ready() -> void:
	visible = true
	for i in saveCaptura.get_children():
		i.disabled = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("tap"):
		self.visible = !self.visible

func _on_capture_button_pressed() -> void:
	imagen = await guardar_hoja_completa()
	for i in saveCaptura.get_children():
		i.disabled = false

func _on_foto_pressed() -> void:
	# Muestra el FileDialog.
	$"../IMG_Save-Load/imgFile_Load".visible = true

func _on_guardar_pressed() -> void:
	$"../IMG_Save-Load/imgFile_Save".visible = true

func _on_file_dialog_file_selected(path: String) -> void:
	# Crea un nuevo objeto Image para cargar los datos del archivo.
	var image = Image.new()
	var error = image.load(path)
	
	# Verifica si la carga fue exitosa.
	if error != OK:
		print("Error al cargar la imagen: ", error)
		return

	# Crea una nueva textura a partir de los datos de la imagen.
	var new_texture = ImageTexture.create_from_image(image)
	
	# Verifica que la textura sea válida y asígnala al TextureRect.
	if new_texture:
		foto_Estudiante.texture = new_texture
		print("Imagen cargada con éxito.")


func _on_img_file_save_file_selected(path: String) -> void:
	# Guarda la imagen en el disco
	var error = imagen.save_png(path)

	if error == OK:
		print("¡Hoja de matrícula guardada correctamente!")
	else:
		print("Error al guardar la imagen. Código de error: ", error)

func guardar_hoja_completa() -> Image:
	var sub_viewport = $"../SubViewport"
	var hoja_original = $"../ScrollContainer"
		
	for child in sub_viewport.get_children():
		if child.name!= "BG":
			print(child, "nodo borrado")
			child.queue_free()
	print( sub_viewport.get_children(), " nodos que sobran")
	
	# Verifica si los nodos son válidos antes de continuar
	if not is_instance_valid(sub_viewport) or not is_instance_valid(hoja_original):
		print("ERROR: Nodos no encontrados.")
		return

	# Oculta el botón y el rectángulo de firma.
	var boton_guardar = $"../ScrollContainer/HBoxContainer/PrincipalContainer_V/HBoxContainer/Guardar"
	var limpiar = $"../ScrollContainer/HBoxContainer/PrincipalContainer_V/HBoxContainer/Limpiar"
	var rectangulo_firma = $"../ScrollContainer/HBoxContainer/PrincipalContainer_V/FirmaTutor/FirmaContainer/FirmaControl/RectanguloFirma"
	if is_instance_valid(boton_guardar):
		boton_guardar.visible = false
	if is_instance_valid(rectangulo_firma):
		rectangulo_firma.visible = false
	if is_instance_valid(limpiar):
		limpiar.visible = false
	
	# --- NUEVO CÓDIGO AÑADIDO ---
	# 1. Obtiene los datos de la firma del componente original antes de duplicarlo.
	var nodo_firma_original = $"../ScrollContainer/HBoxContainer/PrincipalContainer_V/FirmaTutor/FirmaContainer/FirmaControl"
	var puntos_firma_original = nodo_firma_original.get_puntos_firma()
	
	# 2. Duplica el nodo original.
	var hoja_clonada = hoja_original.duplicate()
	
	# 3. Encuentra el nodo de la firma en la copia.
	var nodo_firma_clonada = hoja_clonada.get_node("HBoxContainer/PrincipalContainer_V/FirmaTutor/FirmaContainer/FirmaControl")
	
	# 4. Dibuja las líneas de la firma en el nodo clonado usando los datos originales.
	if is_instance_valid(nodo_firma_clonada):
		var line_container = nodo_firma_clonada.get_node("LineContainer")
		if is_instance_valid(line_container):
			for puntos_linea in puntos_firma_original:
				var nueva_linea = Line2D.new()
				nueva_linea.points = puntos_linea
				nueva_linea.default_color = Color.BLACK
				nueva_linea.width = 2
				line_container.add_child(nueva_linea)
	
	# Añade el clon al SubViewport
	sub_viewport.add_child(hoja_clonada)
	
	# Esperar a que el motor de renderizado complete el dibujo del fotograma
	await RenderingServer.frame_post_draw
	
	# Obtiene la textura del SubViewport y la convierte en una imagen
	var viewport_texture = sub_viewport.get_texture()
	
		# --- Vuelve a mostrar los elementos de la interfaz después de la captura ---
	if is_instance_valid(boton_guardar):
		boton_guardar.visible = true
	if is_instance_valid(rectangulo_firma):
		rectangulo_firma.visible = true
	if is_instance_valid(limpiar):
		limpiar.visible = true
	
	return viewport_texture.get_image()

func _on_fusionar_bases_pressed() -> void:
	var escena_resultado : PackedScene = load("res://Escenas/data_base.tscn")
	var instance_container : VBoxContainer = DataBaseInstance
	var array_fusion: Array = []
	var encabezado_fusion: Array = []
	var has_data_to_fuse = false
	var first_path = ""
	var first_name = ""

	for child in instance_container.get_children():
		if child is HBoxContainer and child.has_node("Fusionar"):
			var checkbox = child.get_node("Fusionar")
			if checkbox.button_pressed:
				var tabla: Array = child.get_data()

				if tabla.size() > 1:
					has_data_to_fuse = true

					if encabezado_fusion.is_empty():
						encabezado_fusion = tabla[0]
						first_path = child.path
						first_name = child.nameCSV

					for i in range(1, tabla.size()):
						array_fusion.append(tabla[i])

	if has_data_to_fuse:
		array_fusion.insert(0, encabezado_fusion)

		var instancia_fusionada : HBoxContainer = escena_resultado.instantiate()
		instancia_fusionada.set_data(array_fusion)
		instancia_fusionada.nameCSV = first_name + "_fusion"
		instancia_fusionada.path = first_path.get_base_dir() + "/fusionado_" + str(Time.get_ticks_msec()) + ".csv"
		
		instance_container.add_child(instancia_fusionada)
	else:
		print("No se encontraron bases de datos seleccionadas o con datos para fusionar.")

#<--------Aqui se maneja la creacion de Bases de Datos-------->
func _on_crear_bd_pressed() -> void:
	# Muestra el FileDialog para que el usuario elija la ruta y el nombre del nuevo archivo CSV.
	$"../CSVDir_Save-Load/CSVFile_Save".visible = true

func _on_csv_file_save_file_selected(path: String) -> void:
	# 1. Configura la librería CsvCtrl con la ruta y los encabezados.
	CsvCtrl.setup(path, CsvCtrl.ENCABEZADOS_MATRICULA)
	CsvCtrl._save_to_file()
	print(CsvCtrl.data, " Qui se vera si esta basio o no")
	
	# 3. Instancia el nodo de la base de datos (data_base.tscn).
	var new_db_node = data_base.instantiate()
	new_db_node.nameCSV = path.get_file().get_basename()
	new_db_node.path = path
	new_db_node.data_BD = CsvCtrl.data
	
	# 5. Añade el nuevo nodo a la interfaz.
	$"../CSVDir_Save-Load/CSVFile_Save".hide()
	
	# Asume que DataBaseInstance es el contenedor de los nodos.
	DataBaseInstance.add_child(new_db_node)


func _on_csv_file_load_files_selected(paths: PackedStringArray) -> void:
	var instance_container = DataBaseInstance
	print(paths)
	for path in paths:
		var file_name = path.get_file().get_basename()
		
		var nodes_to_free = []
		for child in instance_container.get_children():
			if child.has_method("set_data") and child.nameCSV == file_name:
				nodes_to_free.append(child)
		
		for node in nodes_to_free:
			node.queue_free()
			
		# Carga los datos usando tu librería CsvCtrl.
		CsvCtrl.setup(path, CsvCtrl.ENCABEZADOS_MATRICULA)
		CsvCtrl.load_all()
		# Instancia el nodo si la carga fue exitosa.
		if not CsvCtrl.data.is_empty():
			# 3. Instancia el nodo de la base de datos (data_base.tscn).
			var new_db_node = data_base.instantiate()
			new_db_node.nameCSV = path.get_file().get_basename()
			new_db_node.path = path
			new_db_node.data_BD = CsvCtrl.data
			
			instance_container.add_child(new_db_node)
			CsvCtrl.data = []
			print("Base de datos '", file_name, "' instanciada con éxito.")
		else:
			print("El archivo '", file_name, "' no se pudo cargar o está vacío.")

# Esta función auxiliar guarda una sola instancia de base de datos en un archivo CSV.
func _export_database(db_node: HBoxContainer) -> void:
	# 1. Obtén los datos del nodo de la base de datos.
	var data = db_node.get_data()
	var path = db_node.path
	
	# 2. Usa tu librería CsvCtrl para guardar los datos.
	CsvCtrl.setup(path, CsvCtrl.ENCABEZADOS_MATRICULA)
	CsvCtrl.data = data # Establece los datos directamente en el singleton
	CsvCtrl.save_all() # Guarda el conjunto de datos completo

	print("Base de datos exportada con éxito a: ", path)


# Esta función maneja la lógica del botón "Exportar CSV" para las bases de datos seleccionadas.
func _on_exportar_csv_pressed() -> void:
	var instance_container = $PrincipalContainer/DataBaseContainer/BD_Disponibles/BD_Container
	for child in instance_container.get_children():
		if child is HBoxContainer and child.has_node("Exportar"):
			if child.get_node("Exportar").button_pressed:
				_export_database(child)


# Esta función maneja la lógica del botón "Exportar Todo".
func _on_exportar_todo_pressed() -> void:
	var instance_container = DataBaseInstance
	for child in instance_container.get_children():
		if child is HBoxContainer:
			_export_database(child)

func _on_importar_bd_pressed() -> void:
	$"../CSVDir_Save-Load/CSVFile_Load".visible = true
