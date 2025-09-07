extends Control

@onready var foto_Estudiante : TextureRect = $"../ScrollContainer/HBoxContainer/PrincipalContainer_V/Encavezado/Foto_Estudiante"

func _ready() -> void:
	visible = true
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("tap"):
		self.visible = !self.visible


func _on_foto_pressed() -> void:
	# Muestra el FileDialog.
	$"../FileDialog".visible = true


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
