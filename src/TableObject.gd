extends Object

class_name Table

signal newTableAction(action)
signal quit_request()

enum TABLE_ACTION \
{
	HARD_DROP,
	SOFT_DROP,
	HOLD,
	SPIN_L,
	SPIN_R,
	MOVE_L,
	MOVE_R,
	SINGLE_CLEAR,
	DOUBLE_CLEAR,
	TRIPLE_CLEAR,
	TETRIS,
	LEVEL_UP
}

var can_tick = true
var grid = []
var grid_size: Vector2
var ft: Tetromino = null      # Falling tetromino
var nextft: Tetromino = null  # Next random tetromino
var held_tetromino = null
var last_gened_tetromino = -1
var total_lines_cleared = 0
var cleared_counter = 0
var tetrominos = []
var difficulty_level: int

# Called when the node enters the scene tree for the first time.
func _init(difficulty: int = Settings.min_difficulty, grd_sz: Vector2 = Vector2(10,16)):
	self.difficulty_level = difficulty
	self.grid_size = grd_sz
	self.can_tick = true
	setup_tetrominos()
	self.ft = gen_random_tetromino()
	self.nextft = gen_random_tetromino()
	reset_grid()

func setup_tetrominos():
	self.tetrominos = []
	self.tetrominos.append(Tetromino.new(
		[[2,2],
		[2,2]],
		4
	))
	self.tetrominos.append(Tetromino.new(
		[[3,3,3],
		[3,0,0]]
	))
	self.tetrominos.append(Tetromino.new(
		[[4,4,4,4]]
	))
	self.tetrominos.append(Tetromino.new(
		[[5,5,5],
		[0,0,5]]
	))
	self.tetrominos.append(Tetromino.new(
		[[0,6,0],
		[6,6,6]]
	))
	self.tetrominos.append(Tetromino.new(
		[[7,7,0],
		[0,7,7]]
	))
	self.tetrominos.append(Tetromino.new(
		[[0,8,8],
		[8,8,0]]
	))

func reset_grid():
	self.grid = []
	for y in range(grid_size.y):
		self.grid.append([])
		for x in range(grid_size.x):
			self.grid[y].append(0)

func gen_random_tetromino():
	randomize()
	var indexes = []
	for i in len(self.tetrominos) :
		if i != last_gened_tetromino :
			indexes.append(i)
	indexes.shuffle()
	last_gened_tetromino = indexes[0]
	return self.tetrominos[indexes[0]].copy()
	
func check_newft(newft):
	for y in range(len(self.ft.shape)):
		for x in range(len(self.ft.shape[0])):
			var xpos = x+newft.topleft.col
			var ypos = y+newft.topleft.row
			if self.ft.shape[y][x] != 0 and self.grid[ypos][xpos] != 0:
				return false
	return true

func try_moving_left():
	var newft = self.ft.moved_left()
	if (newft.topleft.col != -1) and check_newft(newft):
		self.ft = newft
		emit_signal("newTableAction", TABLE_ACTION.MOVE_L)
		return true
	return false
	
func try_moving_right():
	var newft = self.ft.moved_right()
	if (newft.topleft.col+len(newft.shape[0]) != self.grid_size.x+1) and check_newft(newft):
		self.ft = newft
		emit_signal("newTableAction", TABLE_ACTION.MOVE_R)
		return true
	return false


func try_moving_down():
	var newft = self.ft.moved_down()
	if (newft.topleft.row+len(newft.shape) != self.grid_size.y+1) and check_newft(newft):
		self.ft = newft
		return true
	return false

func can_move_down():
	var newft = self.ft.moved_down()
	return (newft.topleft.row+len(newft.shape) != self.grid_size.y+1) and check_newft(newft)

func try_rotating_left():
	var newft = self.ft.rotated_left()
	if (newft.topleft.col+len(newft.shape[0]) >= self.grid_size.x+1):
		while (newft.topleft.col+len(newft.shape[0]) >= self.grid_size.x+1):
			newft.topleft.col -= 1
	while (newft.topleft.row+len(newft.shape) >= self.grid_size.y+1):
		newft.topleft.row -= 1
	if check_newft(newft):
		self.ft = newft
		emit_signal("newTableAction", TABLE_ACTION.SPIN_L)
		return true
	return false

func try_rotating_right():
	var newft = self.ft.rotated_right()
	while (newft.topleft.col+len(newft.shape[0]) >= self.grid_size.x+1):
			newft.topleft.col -= 1
	while (newft.topleft.row+len(newft.shape) >= self.grid_size.y+1):
		newft.topleft.row -= 1
	if check_newft(newft):
		self.ft = newft
		emit_signal("newTableAction", TABLE_ACTION.SPIN_R)
		return true
	return false

func drop_piece():
	for y in range(len(self.ft.shape)):
		for x in range(len(self.ft.shape[0])):
			var xpos = self.ft.topleft.col+x
			var ypos = self.ft.topleft.row+y
			if self.ft.shape[y][x] != 0:
				self.grid[ypos][xpos] = self.ft.shape[y][x]
	
	emit_signal("newTableAction", TABLE_ACTION.SOFT_DROP)

func hard_drop():
	while (try_moving_down()):
		pass
	
	emit_signal("newTableAction", TABLE_ACTION.HARD_DROP)


func hold_tetromino():
	var current_tetromino: Tetromino = self.ft.copy()
	if held_tetromino == null:
		self.ft = self.nextft.copy()
		self.held_tetromino = current_tetromino
		self.held_tetromino.reset()
		self.nextft = gen_random_tetromino()
	else:
		self.ft = self.held_tetromino.copy()
		self.held_tetromino = current_tetromino
	self.ft.reset()
	
	emit_signal("newTableAction", TABLE_ACTION.HOLD)

func check_lines():
	var lines_cleared = 0
	for y in range(self.grid_size.y):
		var deletable = true
		for x in range(self.grid_size.x):
			if self.grid[y][x] == 0:
				deletable = false
		if (deletable):
			self.grid.remove(y)
			var newline = []
			for i in range(self.grid_size.x):
				newline.append(0)
			self.grid.push_front(newline)
			lines_cleared += 1
	
	self.total_lines_cleared += lines_cleared
	if (lines_cleared >= 1): emit_signal("newTableAction", linesClearedToAction(lines_cleared))
	
	update_level(lines_cleared)
	return lines_cleared

func linesClearedToAction(lines):
	match lines:
		1: return TABLE_ACTION.SINGLE_CLEAR
		2: return TABLE_ACTION.DOUBLE_CLEAR
		3: return TABLE_ACTION.TRIPLE_CLEAR
		4: return TABLE_ACTION.TETRIS

func update_level(lines_cleared):
	if (lines_cleared != 0):
		cleared_counter += lines_cleared
		if cleared_counter>=10 and difficulty_level<Settings.max_difficulty:
			difficulty_level += 1
			cleared_counter = 0
			emit_signal("newTableAction", TABLE_ACTION.LEVEL_UP)

func tick():
	if can_tick:
		if not try_moving_down():
			drop_piece()
			self.ft = self.nextft
			self.nextft = self.gen_random_tetromino()
			if !check_newft(self.ft):
				self.ft = null
				self.nextft = null
				print("ENDGAME - Total score: ", self.total_lines_cleared)
				do_finish_animation()
				can_tick = false
		return check_lines()
	return -1

static func tableActionToString(action) :
	match action:
		TABLE_ACTION.HARD_DROP : return "hardDrop"
		TABLE_ACTION.HOLD : return "hold"
		TABLE_ACTION.SOFT_DROP : return "softDrop"
		TABLE_ACTION.SPIN_L : return "spinLeft"
		TABLE_ACTION.SPIN_R : return "spinRight"
		TABLE_ACTION.MOVE_L : return "moveLeft"
		TABLE_ACTION.MOVE_R : return "moveRight"
		TABLE_ACTION.SINGLE_CLEAR : return "singleClear"
		TABLE_ACTION.DOUBLE_CLEAR : return "doubleClear"
		TABLE_ACTION.TRIPLE_CLEAR : return "tripleClear"
		TABLE_ACTION.TETRIS : return "tetris"
		TABLE_ACTION.LEVEL_UP : return "levelUp"
		_ : return ""

func do_finish_animation():
	var old_hiscore = Utils.load_hiscore()
	var dialog
	if self.total_lines_cleared > old_hiscore:
		dialog = Utils.show_notification("HI SCORE!", "New score: " + str(self.total_lines_cleared))
		Utils.save_hiscore(self.total_lines_cleared)
	else:
		dialog = Utils.show_notification("GAME OVER", "Total score: " + str(self.total_lines_cleared))
	dialog.connect("button_a_pressed", self, "handle_quitting")

func handle_quitting():
	emit_signal("quit_request")
