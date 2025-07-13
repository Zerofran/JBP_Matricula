@tool
extends LineEdit

@export var subrayado_size: float = 1.5:
	set(value):
		subrayado_size = value
		queue_redraw()

func _ready():
	set_process(true)
	queue_redraw()

func _process(_delta):
	# Si quisieras animar algo con el tiempo, lo harías aquí.
	# En este caso solo aseguramos que se redibuje
	queue_redraw()

func _draw():
	var underline_y = size.y - 2
	draw_line(Vector2(0, underline_y), Vector2(size.x, underline_y), Color.BLACK, subrayado_size)
