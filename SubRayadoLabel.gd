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
	# Si está alineado a la izquierda, align_offset queda en 0

	var baseline := font.get_ascent(font_size)
	var underline_y := baseline + 2.0

	draw_line(
		Vector2(align_offset, underline_y),
		Vector2(align_offset + text_size.x, underline_y),
		subrayado_color,
		subrayado_size
	)
