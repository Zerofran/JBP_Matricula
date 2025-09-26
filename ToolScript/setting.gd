extends Control

@onready var foto_Estudiante : TextureRect = $"../ScrollContainer/HBoxContainer/PrincipalContainer_V/Encavezado/Foto_Estudiante"
@onready var Captura: TextureRect = $PrincipalContainer/CapturContainer/captura_matricula
var imagen: Image

#este nodo es usado para instanciar las bases de datos
@onready var DataBaseInstance: VBoxContainer = $PrincipalContainer/DataBaseContainer/BD_Disponibles/BD_Container/DataBaseInstance
var data_base : PackedScene = load("res://Escenas/data_base.tscn") #sera la escena instanciada, a la cual tambien se le pasan los datos leidos del CSV

@onready var saveCaptura = $PrincipalContainer/CapturContainer/saveCaptura
@onready var buttonCapture = $PrincipalContainer/CapturContainer/CaptureButton

var _exportar_todo_modo := false


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
	var databases_to_fuse_count = 0
	
	# Itera sobre los hijos de DataBaseInstance para contar los que están marcados para fusionar.
	if DataBaseInstance:
		for child in DataBaseInstance.get_children():
			# Verifica si el nodo es un HBoxContainer y tiene el nodo de fusión (CheckBox).
			if child is HBoxContainer and child.has_node("Fusion"):
				var fusion_checkbox = child.get_node("Fusion")
				if fusion_checkbox.button_pressed:
					databases_to_fuse_count += 1
	
	# Muestra el diálogo de guardado solo si se seleccionaron más de una base de datos.
	if databases_to_fuse_count > 1:
		$"../CSVDir_Save-Load/CSVFusion_Save".visible = true
	else:
		$"../CSVDir_Save-Load/FusionAlert".visible = true

func _on_crear_bd_pressed() -> void:
	# Muestra el FileDialog para que el usuario elija la ruta y el nombre del nuevo archivo CSV.
	$"../CSVDir_Save-Load/CSVFile_Save".visible = true

func _on_csv_file_save_file_selected(path: String) -> void:
	# 1. Configura la librería CsvCtrl con la ruta y los encabezados.
	CsvCtrl.setup(path, CsvCtrl.ENCABEZADOS_MATRICULA)
	CsvCtrl.data = []
	CsvCtrl._save_to_file()
	
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




func _on_importar_bd_pressed() -> void:
	$"../CSVDir_Save-Load/CSVFile_Load".visible = true


func _on_csv_fusion_save_file_selected(path: String) -> void:
	# Define el contenedor de las bases de datos.
	var instance_container: VBoxContainer = DataBaseInstance
	var array_fusion: Array = []
	
	# Recorre los nodos hijos para encontrar las bases de datos seleccionadas.
	for child in instance_container.get_children():
		# Verifica si el nodo es una base de datos y si el botón de fusión está activado.
		# Asumo que el botón 'Fusion' es un CheckBox.
		if child is HBoxContainer and child.has_node("Fusion"):
			var checkbox = child.get_node("Fusion")
			if checkbox.button_pressed:
				var tabla: Array = child.data_BD
				
				# Asegúrate de que la base de datos no esté vacía.
				if tabla.size() > 1:
					# Añade los datos (filas) de la base de datos a nuestro array de fusión.
					# Se ignora el primer elemento porque son los encabezados.
					for i in range(1, tabla.size()):
						array_fusion.append(tabla[i])
	
	# Si se encontró información para fusionar, se procede con la creación de la nueva BD.
	if not array_fusion.is_empty():
		var escena_resultado: PackedScene = load("res://Escenas/data_base.tscn")
		
		# Añade los encabezados al inicio del array fusionado.
		array_fusion.insert(0, CsvCtrl.ENCABEZADOS_MATRICULA)
		
		var instancia_fusionada: HBoxContainer = escena_resultado.instantiate()
		
		# Asigna los datos y propiedades a la nueva instancia.
		instancia_fusionada.data_BD = array_fusion
		instancia_fusionada.nameCSV = path.get_file().get_basename()
		instancia_fusionada.path = path
		
		# Añade la nueva instancia a la interfaz.
		instance_container.add_child(instancia_fusionada)
		
		# Puedes guardar el archivo fusionado aquí si es necesario.
		CsvCtrl.setup(path, CsvCtrl.ENCABEZADOS_MATRICULA)
		CsvCtrl.data = array_fusion
		CsvCtrl.save_all()
		
		print("Bases de datos seleccionadas fusionadas con éxito.")
	else:
		print("No se encontraron bases de datos seleccionadas o con datos para fusionar.")


func _on_csv_free_save_dir_selected(dir: String) -> void:
	print("Directorio seleccionado: ", dir)
	
	# Asegúrate de que el directorio de destino exista. Si no, lo crea de forma recursiva.
	var dir_access = DirAccess.open("user://")
	if not dir_access.dir_exists_absolute(dir):
		var error = dir_access.make_dir_recursive(dir)
		if error != OK:
			print("Error al crear el directorio: ", error)
			return
	
	for db_instance in DataBaseInstance.get_children():
		var exportar_db := false
		
		# Si el modo "Exportar Todo" está activo, siempre exporta.
		if _exportar_todo_modo:
			exportar_db = true
		else:
			# Si no, verifica si el botón "Exportar" está presionado.
			var exportar_node = db_instance.get_node("Exportar").button_pressed
			if exportar_node:
				exportar_db = true
		
		if exportar_db:
			var path = dir.path_join(db_instance.nameCSV + ".csv")
			var data = db_instance.data_BD
			
			# Itera sobre cada fila para modificar las columnas de firma y foto
			for row in data:
				# El código original era data[28], lo que causaba el error.
				# Ahora, se accede a la celda correcta dentro de cada fila.
				if typeof(row[28]) == 4:
					row[28] = "FirmaTutor"
				else:
					row[28] = str(row[28])
					row[28] = "FirmaRTutor"
					
				row[30] = "imagenEstudiante"
			CsvCtrl.setup(path, CsvCtrl.ENCABEZADOS_MATRICULA)
			CsvCtrl.data = data
			CsvCtrl._save_to_file()

func _on_exportar_csv_pressed() -> void:
	_exportar_todo_modo = false
	$"../CSVDir_Save-Load/CSVFree_Save".visible = true

func _on_exportar_todo_pressed() -> void:
	_exportar_todo_modo = true
	$"../CSVDir_Save-Load/CSVFree_Save".visible = true
