extends GridContainer

signal newTableAction(action)
signal newScore(score)
signal newLevel(level)

onready var img = preload("res://assets/block.png")

var table: Table = null
var tick_timer = 0
var tick_max = 0.5
var paused = false

func _ready():
	var hiscore = Utils.load_hiscore()
	if (hiscore == -1):
		hiscore = 0
	get_tree().root.get_node("Control/HiscorePanel/HiscoreLabel").text = str(hiscore)
	
	var passedLevel = SceneSwitcher.get_param("level")
	if passedLevel == null:
		passedLevel = Settings.min_difficulty
	tick_max = 1 - range_lerp(passedLevel, Settings.min_difficulty, Settings.max_difficulty, 0.5, 0.8)
	table = Table.new(passedLevel)
	table.connect("lines_cleared", self, "handle_lines_cleared")
	table.connect("level_up", self, "handle_level_up")
	redraw()

func toggle_pause(p):
	paused = p

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !table.can_tick or paused:
		return
	table.check_lines()
	tick_timer += delta
	
	if Input.is_action_just_pressed("hard_drop"):
		table.hard_drop()
		emit_signal("newTableAction", Table.TABLE_ACTION.HARD_DROP)
		tick_timer = tick_max/2
	if Input.is_action_just_pressed("soft_drop"):
		table.tick()
		emit_signal("newTableAction", Table.TABLE_ACTION.SOFT_DROP)
		tick_timer = 0#tick_max/2
		
	if Input.is_action_just_pressed("hold"):
		table.hold_tetromino()
		emit_signal("newTableAction", Table.TABLE_ACTION.HOLD)
		tick_timer = tick_max/4
	if Input.is_action_just_pressed("spin_left"):
		table.try_rotating_left()
		emit_signal("newTableAction", Table.TABLE_ACTION.SPIN_L)
		tick_timer = tick_max/4
	if Input.is_action_just_pressed("spin_right"):
		table.try_rotating_right()
		emit_signal("newTableAction", Table.TABLE_ACTION.SPIN_R)
		tick_timer = tick_max/4
	if Input.is_action_just_pressed("move_left"):
		table.try_moving_left()
		emit_signal("newTableAction", Table.TABLE_ACTION.MOVE_L)
		tick_timer = tick_max/4
	if Input.is_action_just_pressed("move_right"):
		table.try_moving_right()
		emit_signal("newTableAction", Table.TABLE_ACTION.MOVE_R)
		tick_timer = tick_max/4
		
	self.redraw()
		
	if (tick_timer >= tick_max):
		tick_timer = 0
		table.tick()
		if table.can_tick:
			self.redraw()

func redraw():
	for child in get_children():
		child.queue_free()
	for y in range(len(table.grid)):
		for x in range(len(table.grid[y])):
			var texrect = TextureRect.new()
			texrect.rect_min_size = Vector2(8,8)
			if (table.grid[y][x] != 0):
				texrect.texture = Tetromino.get_texture_from_value(table.grid[y][x])
			if table.ft.containsPoint(x, y) :
				var value = table.ft.valueAtPoint(x, y)
				if (value > 0):
					texrect.texture = Tetromino.get_texture_from_value(value)
			add_child(texrect)

func handle_lines_cleared(amount):
	var text = ["SINGLE!", "DOUBLE!", "TRIPLE!", "TETRIS!"][amount-1]
	
	var action = 0
	
	match amount :
		1 : action = Table.TABLE_ACTION.SINGLE_CLEAR
		2 : action = Table.TABLE_ACTION.DOUBLE_CLEAR
		3 : action = Table.TABLE_ACTION.TRIPLE_CLEAR
		4 : action = Table.TABLE_ACTION.TETRIS
	
	emit_signal("newTableAction", action)
	emit_signal("newScore", table.total_lines_cleared)
	
	get_tree().root.add_child(Alert.show_alert(text))


func handle_level_up():
	yield(get_tree().create_timer(1.4), "timeout")
	
	emit_signal("newTableAction", Table.TABLE_ACTION.LEVEL_UP)
	emit_signal("newLevel", table.difficulty_level)
	
	get_tree().root.add_child(Alert.show_alert("Level up!"))
