extends Object
class_name Table

var grid = []
var grid_size: Vector2

var ft: Tetromino = null      # Falling tetromino
var nextft: Tetromino = null  # Next random tetromino

var tetrominos = []

# Called when the node enters the scene tree for the first time.
func _init(grid_size: Vector2 = Vector2(10,16)):
	self.grid_size = grid_size
	setup_tetrominos()
	self.ft = gen_random_tetromino()
	self.nextft = gen_random_tetromino()
	reset_grid()


func setup_tetrominos():
	self.tetrominos = []
	self.tetrominos.append(Tetromino.new([[2,2],[2,2]],{'row':0,'col':4}))
	self.tetrominos.append(Tetromino.new(
		[[3,3,3],
		[3,0,0]]
	))
	self.tetrominos.append(Tetromino.new(
		[[4,4,4,4]],
		{'row':0,'col':3}
	))
	self.tetrominos.append(Tetromino.new(
		[[4],[4],[4],[4]],
		{'row':0,'col':4}
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
	return
	self.grid[0][0] = 4
	self.grid[0][1] = 4
	self.grid[0][9] = 4
	self.grid[1][9] = 4


func gen_random_tetromino():
	randomize()
	return self.tetrominos[(randi()+1)%(len(self.tetrominos)-1)].copy()
	
func check_newft(newft):
	for y in range(len(self.ft.shape)):
		for x in range(len(self.ft.shape[0])):
			var xpos = x+newft.topleft.col
			var ypos = y+newft.topleft.row
			if self.ft.shape[y][x] != 0:
				if self.grid[ypos][xpos] != 0:
					return false
	return true


func try_moving_left():
	var newft = self.ft.moved_left()
	if (newft.topleft.col == -1):
		return false
	if not check_newft(newft):
		return false
	self.ft = newft
	return true
	
	
func try_moving_right():
	var newft = self.ft.moved_right()
	if (newft.topleft.col+len(newft.shape) == 10):
		return false
	if not check_newft(newft):
		return false
	self.ft = newft
	return true


func try_moving_down():
	var newft = self.ft.moved_down()
	if (newft.topleft.row+len(newft.shape[0]) == 18):
		return false
	if not check_newft(newft):
		return false
	self.ft = newft
	return true


func drop_piece():
	print("-------------")
	for y in range(len(self.ft.shape)):
		for x in range(len(self.ft.shape[0])):
			var xpos = self.ft.topleft.col+x
			var ypos = self.ft.topleft.row+y
			if self.ft.shape[y][x] != 0:
				self.grid[ypos][xpos] = self.ft.shape[y][x]
	#for row in self.grid:
	#	print(row)


func hard_drop():
	while (try_moving_down()):
		pass
	drop_piece()
	self.ft = self.nextft
	self.nextft = self.gen_random_tetromino()


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
			for i in range(self.grid_size.y):
				newline.append(0)
			self.grid.append(newline)
			lines_cleared += 1
	return lines_cleared



func tick():
	if try_moving_down():
		return false
	else:
		drop_piece()
		self.ft = self.nextft
		self.nextft = self.gen_random_tetromino()
	return check_lines()
	#return false