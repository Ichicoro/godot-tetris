extends Object
class_name Table

var grid = []
var grid_size: Vector2

var ft: Tetromino = null     # Falling tetromino

# Called when the node enters the scene tree for the first time.
func _init(grid_size: Vector2 = Vector2(10,16)):
	self.grid_size = grid_size
	self.ft = gen_random_tetromino()
	reset_grid()


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
	return Tetromino.new([[0,6,0],[6,6,6]])
	
func check_newft(newft):
	for y in range(len(self.ft.shape)):
		for x in range(len(self.ft.shape[0])):
			var xpos = x+newft.topleft.col
			var ypos = y-newft.topleft.row
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


func tick():
	if try_moving_down():
		return true
	return false