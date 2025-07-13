@tool
extends Label

@export var subrayado_size: float = 1.5:
	set(value):
		subrayado_size = value
		queue_redraw()

@export var subrayado_color: Color = Color.BLACK:
	set(value):
		subrayado_color = value
		queue_redraw()

@export var subrayado_padding: float = 5.0:
	set(value):
		subrayado_padding = value
		queue_redraw()

@export var segunda_linea_activa: bool = false:
	set(value):
		segunda_linea_activa = value
		queue_redraw()

@export var segunda_linea_separacion: float = 3.0:
	set(value):
		segunda_linea_separacion = value
		queue_redraw()

@export var segunda_linea_grosor: float = 1.5:
	set(value):
		segunda_linea_grosor = value
		queue_redraw()

@export var segunda_linea_color: Color = Color.BLACK:
	set(value):
		segunda_linea_color = value
		queue_redraw()

func _ready():
	set_process(true)
	queue_redraw()

func _process(_delta):
	queue_redraw()

func _draw():
	if text == "":
		return

	var font := get_theme_font("font")
	var font_size := get_theme_font_size("font_size")
	var text_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)

	var align_offset := 0.0
	if horizontal_alignment == HORIZONTAL_ALIGNMENT_CENTER:
		align_offset = (size.x - text_size.x) / 2.0
	elif horizontal_alignment == HORIZONTAL_ALIGNMENT_RIGHT:
		align_offset = (size.x - text_size.x)

	var baseline := font.get_ascent(font_size)
	var underline_y := baseline + 2.0

	var start_x := align_offset - subrayado_padding
	var end_x := align_offset + text_size.x + subrayado_padding

	# Primera línea
	draw_line(
		Vector2(start_x, underline_y),
		Vector2(end_x, underline_y),
		subrayado_color,
		subrayado_size
	)

	# Segunda línea (opcional)
	if segunda_linea_activa:
		var y2 := underline_y + segunda_linea_separacion
		draw_line(
			Vector2(start_x, y2),
			Vector2(end_x, y2),
			segunda_linea_color,
			segunda_linea_grosor
		)
