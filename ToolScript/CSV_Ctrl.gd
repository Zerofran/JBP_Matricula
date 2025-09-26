
# CSV Manager - Librería para operaciones CRUD en archivos CSV
extends Node

var file_path: String = ""
var headers: Array = []
var data: Array = []
const ENCABEZADOS_MATRICULA: Array = [
	"Codigo", "NombreEstudiante", "LugarNacimiento", "Edad", "Sexo", 
	"Direccion", "GradoAprobado", "GradoPorCursar", "Repitente","CentroProcedencia", 
	"NombrePadre","CedulaPadre", "CelularPadre", "CorreoPadre", 
	"NombreMadre","CedulaMadre","CelularMadre", "CorreoMadre",
	"NombreTutor","CedulaTutor","CelularTutor", "CorreoTutor",
	"PartidaNacimiento","NotaAnterior", "hojaTraslado","CopiaDiploma", "CopiaCedulaFamiliar-Tutor",
	"FechaMatricula", "Firma", "NombreGestor", "fotoEstudiante"
	]
var DATOS_POR_DEFECTO: Array = [
	"New", "Nombre no asignado", "0", "4", "9", 
	"2", "test", "0", "2","2", 
	"w","f", "f", "f", 
	"f","f","f", "f",
	"f","f","f", "f",
	"f","f", "f","f", "f",
	"f", "f", "f", "f"
	]

func _ready() -> void:
	pass

#region CRUD - Funciones Principales
#-------------------------------------------------------------------------------------------------
# Carga el archivo CSV desde una ruta y lo lee.
func load_all() -> void:
	if not FileAccess.file_exists(file_path):
		print("No se encontró el archivo en: ", file_path)
		data = []
		headers = []
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text().split("\n")
	file.close()

	if content.is_empty() or (content.size() == 1 and content[0].is_empty()):
		print("El archivo está vacío.")
		data = []
		headers = []
		return

	#headers = content.pop_front().split(";")
	data = []

	for row_string in content:
		if not row_string.is_empty():
			var row_array = row_string.split(";")
			# Reconstruir firma si es string
			if row_array.size() > 28 and row_array[28] is String and row_array[28].begins_with("["):
				var parsed = str_to_var(row_array[28])
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
					#row_array[28] = firma_array  la firma no se añade
			data.append(row_array)

# Añade un nuevo registro (fila) a la base de datos en memoria.
func add_record(new_record: Array) -> void:
	data.append(new_record)
	_save_to_file()

# Actualiza un registro existente por su índice (número de fila).
func update_record(index: int, updated_record: Array) -> void:
	if index >= 0 and index < data.size():
		data[index] = updated_record
		_save_to_file()

# Elimina un registro por su índice(número de fila).
func delete_record(index: int) -> void:
	if index >= 0 and index < data.size():
		data.remove_at(index)
		_save_to_file()

# Guarda todos los datos en memoria (encabezados y filas) en el archivo CSV.
func save_all() -> void:
	_save_to_file()

# Busca y devuelve un array de registros que coincidan con un valor.
func filter_by_value(value_to_find: String) -> Array:
	var filtered_results: Array = []
	for record in data:
		if record.has(value_to_find):
			filtered_results.append(record)
	return filtered_results

#-------------------------------------------------------------------------------------------------
# Convierte una textura a una cadena Base64.
func texture_to_base64(texture: Texture2D) -> String:
	if not texture:
		return ""
	var image = texture.get_image()
	var png_bytes = image.save_png_to_buffer()
	return Marshalls.raw_to_base64(png_bytes)

# Convierte una cadena Base64 a una textura.
func base64_to_texture(base64_string: String) -> Texture2D:
	if base64_string.is_empty():
		return null
	var png_bytes = Marshalls.base64_to_raw(base64_string)
	var image = Image.new()
	var error = image.load_png_from_buffer(png_bytes)
	if error != OK:
		print("Error al decodificar la imagen: ", error)
		return null
	return ImageTexture.create_from_image(image)

#endregion


#region Ordenación
#-------------------------------------------------------------------------------------------------

# Ordena los datos de mayor a menor o de menor a mayor, numérica o alfabéticamente.
func sort_data(column_index: int, is_ascending: bool = true, is_numeric: bool = false) -> void:
	if data.is_empty() or column_index < 0 or column_index >= headers.size():
		print("Error: Los datos están vacíos o el índice de columna no es válido.")
		return
	
	# La corrección: Usa una función anónima para encapsular la lógica de ordenación.
	data.sort_custom(func(a, b):
		var value_a = a[column_index]
		var value_b = b[column_index]
		
		if is_numeric:
			value_a = float(value_a)
			value_b = float(value_b)
		
		if is_ascending:
			return value_a < value_b
		else:
			return value_a > value_b
	)

#-------------------------------------------------------------------------------------------------
#endregion


#region Funciones Auxiliares y Herramientas
#-------------------------------------------------------------------------------------------------

# Configura la ruta y los encabezados del archivo.
# Se llama una sola vez antes de usar las funciones principales.
func setup(path: String, new_headers: Array) -> void:
	file_path = path
	headers = new_headers

# Guarda los datos en el archivo CSV (función auxiliar).
# No debe ser llamada directamente desde otros scripts.
func _save_to_file() -> void:
	if file_path.is_empty():
		print("Error: No se puede guardar, la ruta del archivo no está definida.")
		return
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		print("Error al escribir el archivo: %s" % FileAccess.get_open_error())
		return

	file.store_csv_line(headers, ";")

	for row in data:
		var row_copy = Array(row)
		if row_copy.size() > 28 and row_copy[28] is Array:
			var firma_serializable = []
			for trazo in row_copy[28]:
				firma_serializable.append(Array(trazo))
			row_copy[28] = str(firma_serializable)
		file.store_csv_line(row_copy, ";")
	file.close()

# Convierte un string con formato de Vector3 a un objeto Vector3.
# Útil si almacenas coordenadas en el CSV.
func string_to_vector3(vector_string: String) -> Vector3:
	var vector_values: Array = vector_string.split(";")
	var result_vector: Vector3 = Vector3()
	if vector_values.size() >= 3:
		result_vector.x = float(vector_values[0])
		result_vector.y = float(vector_values[1])
		result_vector.z = float(vector_values[2])
	return result_vector

#endregion
