extends GridContainer

onready var img = preload("res://assets/block.png")

var table = null
var tick_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	table = Table.new()
	
	for y in range(len(table.grid)):
		for x in range(len(table.grid[y])):
			var texrect = TextureRect.new()
			texrect.rect_min_size = Vector2(16,16)
			if (table.grid[y][x] != 0):
				texrect.texture = img
				texrect.modulate = Tetromino.get_tint_from_value(table.grid[y][x])
			if (y in range(table.ft.topleft.row, table.ft.topleft.row+len(table.ft.shape)) and x in range(table.ft.topleft.col, table.ft.topleft.col+len(table.ft.shape[y]))):
				if (table.ft.shape[table.ft.topleft.row - y][table.ft.topleft.col - x-1] != 0):
					texrect.texture = img
					texrect.modulate = Tetromino.get_tint_from_value(table.ft.shape[table.ft.topleft.row - y][table.ft.topleft.col - x-1])
			add_child(texrect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tick_timer += delta
	if Input.is_action_just_pressed("move_left"):
		var result = table.try_moving_left()
		self.redraw()
	if Input.is_action_just_pressed("move_right"):
		var result = table.try_moving_right()
		self.redraw()
	if Input.is_action_just_pressed("hard_drop"):
		table.hard_drop()
		self.redraw()
	if (tick_timer >= 0.5):
		tick_timer = 0
		var result = table.tick()
		self.redraw()


func redraw():
	for child in get_children():
		child.queue_free()
	for y in range(len(table.grid)):
		for x in range(len(table.grid[y])):
			var texrect = TextureRect.new()
			texrect.rect_min_size = Vector2(16,16)
			if (table.grid[y][x] != 0):
				texrect.texture = img
				texrect.modulate = Tetromino.get_tint_from_value(table.grid[y][x])
			if (y in range(table.ft.topleft.row, table.ft.topleft.row+len(table.ft.shape)) and x in range(table.ft.topleft.col, table.ft.topleft.col+len(table.ft.shape[0]))):
				if (table.ft.shape[table.ft.topleft.row - y][table.ft.topleft.col - x-1] != 0):
					texrect.texture = img
					texrect.modulate = Tetromino.get_tint_from_value(table.ft.shape[table.ft.topleft.row - y][table.ft.topleft.col - x-1])
			add_child(texrect)
