extends GridContainer

signal newScore(score)
signal newLevel(level)

var table: Table = null
var tick_timer = 0
var tick_max = 0.5
var pause_lockable = false
var pause_locked_time = 0
var paused = false

func _ready():
	var passedLevel = SceneSwitcher.get_param("level")
	if passedLevel == null:
		passedLevel = Settings.min_difficulty
	tick_max = 1 - range_lerp(passedLevel, Settings.min_difficulty, Settings.max_difficulty, 0.5, 0.8)
	table = Table.new(passedLevel)
	table.connect("newTableAction", self, "handleTableAction")
	table.connect("quit_request", self, "handle_quitting")
	
	emit_signal("newScore", 0)
	emit_signal("newLevel", Settings.min_difficulty)
	
	redraw()

func toggle_pause(p):
	paused = p

func handleTableAction(action) :
	if action in range(Table.TABLE_ACTION.SINGLE_CLEAR, Table.TABLE_ACTION.TETRIS+1) :
		handle_lines_cleared(action - Table.TABLE_ACTION.SINGLE_CLEAR + 1)
	if action == Table.TABLE_ACTION.LEVEL_UP :
		handle_level_up()


func _process(delta):
	if !table.can_tick or paused:
		return
	
	var did_act = false
	table.check_lines()
	
	if not table.can_move_down():
		pause_lockable = (pause_locked_time >= -delta*2 and pause_locked_time <= 5)
		if not pause_lockable:
			pause_locked_time = 0
	else:
		pause_lockable = false
		pause_locked_time = 0
	
	if Input.is_action_just_pressed("hard_drop"):
		table.hard_drop()
		did_act = true
	if Input.is_action_just_pressed("soft_drop"):
		table.tick()
		did_act = true
	if Input.is_action_just_pressed("hold"):
		table.hold_tetromino()
		did_act = true
	if Input.is_action_just_pressed("spin_left"):
		table.try_rotating_left()
		did_act = true
	if Input.is_action_just_pressed("spin_right"):
		table.try_rotating_right()
		did_act = true
	if Input.is_action_just_pressed("move_left"):
		table.try_moving_left()
		did_act = true
	if Input.is_action_just_pressed("move_right"):
		table.try_moving_right()
		did_act = true
	
	if did_act and pause_lockable:
		tick_timer = max(0, tick_timer-delta)
		pause_locked_time += delta
	else:
		tick_timer += delta
	
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

func connectTableSignal(sourceSignal : String, receiver : Node, receiverSignal : String) :
	table.connect(sourceSignal, receiver, receiverSignal)

func handle_lines_cleared(amount = 1):
	emit_signal("newScore", table.total_lines_cleared)
	get_tree().root.add_child(Alert.show_alert(amount))

func handle_level_up():
	emit_signal("newLevel", table.difficulty_level)
	yield(get_tree().create_timer(1), "timeout")
	get_tree().root.add_child(Alert.show_alert(Table.TABLE_ACTION.LEVEL_UP))

func handle_quitting():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
