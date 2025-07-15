extends Control

@onready var _lines: Node2D = $LineContainer
var _historial_lineas: Array = []

var _pressed := false
var _current_line: Line2D

func _ready():
	set_process_unhandled_key_input(true)
	focus_mode = FOCUS_ALL

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and _esta_dentro(event.position):
			_pressed = true
			_current_line = Line2D.new()
			_current_line.default_color = Color.BLACK
			_current_line.width = 2
			_lines.add_child(_current_line)
			_historial_lineas.append(_current_line)  # ← guardamos en historial

			var punto = _convertir_a_local_normalizado(event.position)
			_current_line.add_point(punto * size)
		else:
			_pressed = false

	elif event is InputEventMouseMotion and _pressed:
		var punto = _convertir_a_local_normalizado(event.position)
		_current_line.add_point(punto * size)

func _convertir_a_local_normalizado(local_pos: Vector2) -> Vector2:
	var rel = local_pos / size
	return rel.clamp(Vector2.ZERO, Vector2.ONE)

func _esta_dentro(local_pos: Vector2) -> bool:
	return Rect2(Vector2.ZERO, size).has_point(local_pos)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.ctrl_pressed and event.keycode == KEY_Z:
			if _mouse_esta_dentro():
				_deshacer_ultimo_trazo()

func _mouse_esta_dentro() -> bool:
	var mouse_local_pos = get_local_mouse_position()
	return Rect2(Vector2.ZERO, size).has_point(mouse_local_pos)

func _deshacer_ultimo_trazo():
	if _historial_lineas.size() > 0:
		var ultima_linea = _historial_lineas.pop_back()
		if is_instance_valid(ultima_linea):
			ultima_linea.queue_free()
