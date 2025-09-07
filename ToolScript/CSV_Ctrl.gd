extends Node

var doc = "res://"
var titulos = ["nombre", "edad"]
const  encavezado : Array = ["Id", "Nombre", "Tipo", "masa", "posicion", "altura", "asce recta i", "asce recta f",
"Declin i", "Declin f", "Vel angular", "Vel Tangencial", "Fecha", "Fecha Juliana", "Tiempo UTC"]

# esta funcion setea los parametros con los que se van a trabajar asi que se debe ejecutar primero
func  setting(Url:String, Titulos: Array, Name: String = "defaul.csv"):
	doc = Url + Name
	titulos = Titulos
	print(doc, " ruta al documento")

#esta es la funcion de escribir
func _escribir(Datos: Array = []):
	var documento = _leer()
	var file = FileAccess.open(doc, FileAccess.WRITE)
	if documento.size() == 0:
		file.store_csv_line(titulos, ";")
		print(documento.size(), " tamaño del doc")
	else:
		for i in documento.size():
			var datos : Array = documento[i]
			file.store_csv_line(datos, ";")

	if Datos != []:
		file.store_csv_line(Datos, ";")
		print(Datos, "prueba 2")
	file.close()

#esta resescribe y esta compuesta de dos partes, una que borra un elemento en concreto y otra
#que reescribe un elemento en concreto solo que la termino, esta funcion no se debe de llamar, es auxiliar
func _Re_escribir(valor:Array, modo: bool = true ):
	if modo == true:
		var file = FileAccess.open(doc, FileAccess.WRITE)
		if valor.size() == 0:
			print_rich("[color=red][b]No hay datos que leer[/b][/color]")
		else:
			for i in valor.size():
				var datos = valor[i]
				#datos.erase("")
				file.store_csv_line(datos, ";")
		file.close()
	else:
		#aqui se pondra la logica de el digito a sobre escribir
		pass

#funcion que lee el Csv, devuelve un array bidimencional
func _leer():
	var file = FileAccess.open(doc, FileAccess.READ)
	if (not FileAccess.file_exists(doc)):
		print("no hay datos que cargar")
		return []
	var contenido = file.get_as_text()
	contenido = contenido.split("\n")
	contenido = Array(contenido)
	contenido.erase("")

	var datos:Array = []
	for i in contenido:
		i = i.split(";")
		i = Array(i)
		#i.erase("")  # esto borraba el ultimo elemento basio del array
		datos.append(i)
	file.close()
	return datos

#esta es la que borra y usa a re escribir para auxiliarse
func _borrar(valor) -> void:
	var datos:Array = _leer()
	var borrar: Array = _leer()
	datos.erase(borrar[valor])
	_Re_escribir(datos)

func filtroPorTipo(lista: Array, debri:bool = true) -> Array:
	var Tipo : String
	if debri:
		Tipo = "debris"
	else:
		Tipo = "satelite"
	var ResultadoFiltrado : Array
	for i in lista.size():
		if i != 0:
			for a in lista[i].size():
				if lista[i][a] == Tipo:
					ResultadoFiltrado.append_array(lista[i])
					
	return ResultadoFiltrado

func  FormatoDeVariables(Lista: Array):
	pass
