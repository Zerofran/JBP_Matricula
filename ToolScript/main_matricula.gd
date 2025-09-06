extends Control


func _ready() -> void:
	print("Script cargado y listo para depurar. Presiona 'p'.")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("p"):
		print("Detectada la acción 'p'. Iniciando proceso de guardado...")
		guardar_hoja_completa()
	

func guardar_hoja_completa():
	# Primero, limpia el SubViewport de cualquier contenido anterior.
	# Esto evita la duplicación de nodos y fugas de memoria.
	for child in $SubViewport.get_children():
		if child.name!= "BG":
			print(child, "nodo borrado")
			child.queue_free()
	print( $SubViewport.get_children(), " nodos que sobran")

	# Obtén una referencia a los nodos SubViewport y ScrollContainer
	var sub_viewport = $SubViewport
	var hoja_original = $ScrollContainer
	
	# Verifica si los nodos son válidos antes de continuar
	if not is_instance_valid(sub_viewport) or not is_instance_valid(hoja_original):
		print("ERROR: Nodos no encontrados.")
		return

	# Oculta el botón y el rectángulo de firma.
	var boton_guardar = $ScrollContainer/HBoxContainer/PrincipalContainer_V/Guardar
	var rectangulo_firma = $ScrollContainer/HBoxContainer/PrincipalContainer_V/FirmaTutor/FirmaContainer/FirmaControl/RectanguloFirma
	if is_instance_valid(boton_guardar):
		boton_guardar.visible = false
	if is_instance_valid(rectangulo_firma):
		rectangulo_firma.visible = false
	
	# Duplica el nodo original para evitar alterar la escena visible
	var hoja_clonada = hoja_original.duplicate()
	
	# Añade el clon al SubViewport
	sub_viewport.add_child(hoja_clonada)
	
	# Esperar a que el motor de renderizado complete el dibujo del fotograma
	await RenderingServer.frame_post_draw
	
	# Obtiene la textura del SubViewport y la convierte en una imagen
	var viewport_texture = sub_viewport.get_texture()
	var image = viewport_texture.get_image()
	
	# Guarda la imagen en el disco
	var error = image.save_png("res://hoja_matricula_completa.png")
	
	# Libera el nodo clonado de la memoria para limpiar la escena
	#hoja_clonada.queue_free()

	# --- Vuelve a mostrar los elementos de la interfaz después de la captura ---
	#hoja_original.get_v_scrollbar().visible = true
	if is_instance_valid(boton_guardar):
		boton_guardar.visible = true
	if is_instance_valid(rectangulo_firma):
		rectangulo_firma.visible = true

	if error == OK:
		print("¡Hoja de matrícula guardada correctamente!")
	else:
		print("Error al guardar la imagen. Código de error: ", error)

func _on_capture_button_pressed() -> void:
	guardar_hoja_completa()
