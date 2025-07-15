extends Control

@onready var _lines: Node2D = $LineContainer

var _historial_lineas: Array = []  # Lista de arrays de puntos
var _historial_rehacer: Array = [] # Lista de arrays de puntos

var _pressed := false
var _current_line: Line2D
var _current_points: Array = []

func _ready():
	set_process_unhandled_key_input(true)
	focus_mode = FOCUS_ALL

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and _esta_dentro(event.position):
			_iniciar_nueva_linea(event.position)
		else:
			_finalizar_linea()

	elif event is InputEventMouseMotion and _pressed:
		_agregar_punto(event.position)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_finalizar_linea()

func _iniciar_nueva_linea(pos: Vector2) -> void:
	_pressed = true
	_current_line = Line2D.new()
	_current_line.default_color = Color.BLACK
	_current_line.width = 2
	_lines.add_child(_current_line)

	_current_points = []
	_historial_rehacer.clear()

	var punto = _convertir_a_local_normalizado(pos) * size
	_current_points.append(punto)
	_current_line.add_point(punto)

func _agregar_punto(pos: Vector2) -> void:
	if not _pressed:
		return
	var punto = _convertir_a_local_normalizado(pos) * size
	_current_points.append(punto)
	_current_line.add_point(punto)

func _finalizar_linea() -> void:
	if _pressed and _current_points.size() > 0:
		_historial_lineas.append(_current_points.duplicate())
	_current_line = null
	_current_points.clear()
	_pressed = false

func _convertir_a_local_normalizado(local_pos: Vector2) -> Vector2:
	var rel = local_pos / size
	return rel.clamp(Vector2.ZERO, Vector2.ONE)

func _esta_dentro(local_pos: Vector2) -> bool:
	return Rect2(Vector2.ZERO, size).has_point(local_pos)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.ctrl_pressed:
		if event.keycode == KEY_Z and _mouse_esta_dentro():
			_deshacer()
		elif event.keycode == KEY_Y and _mouse_esta_dentro():
			_rehacer()

func _mouse_esta_dentro() -> bool:
	var pos = get_local_mouse_position()
	return Rect2(Vector2.ZERO, size).has_point(pos)

func _deshacer():
	# No permitimos deshacer mientras se está dibujando
	if _pressed:
		return

	if _historial_lineas.size() > 0 and _lines.get_child_count() > 0:
		var ultima_linea = _lines.get_child(_lines.get_child_count() - 1)
		var puntos = _historial_lineas.pop_back()
		_historial_rehacer.append(puntos)
		ultima_linea.queue_free()

func _rehacer():
	if _historial_rehacer.size() > 0:
		var puntos: Array = _historial_rehacer.pop_back()
		var nueva = Line2D.new()
		nueva.default_color = Color.BLACK
		nueva.width = 2
		for p in puntos:
			nueva.add_point(p)
		_lines.add_child(nueva)
		_historial_lineas.append(puntos)
