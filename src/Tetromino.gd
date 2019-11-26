extends Object
class_name Tetromino

var shape = []
var topleft
var def_topleft

const colors = {
	0: Color(1,1,1,0.1), 				# no tetromino
	1: Color(1,1,1,1),           		# debug
	2: Color(1.0, 0.88, 0.19, 1),        # cube
	3: Color(1.0, 0.31, 0.31, 1),        # lshaped
	4: Color(0.27, 0.69, 1.0, 1),        # longboi
	5: Color(1.0, 0.67, 0.23, 1),        # rlshaped
	6: Color(0.67, 0.23, 1.0, 1),        # Tshaped
	7: Color(1.0, .08, .08, 1),
	8: Color(.12, 1.0, .12, 1)
}

const textures = {
	0: null,
	1: preload("res://assets/tetrominos/debug.png"),
	2: preload("res://assets/tetrominos/o.png"),
	3: preload("res://assets/tetrominos/l.png"),
	4: preload("res://assets/tetrominos/i.png"),
	5: preload("res://assets/tetrominos/j.png"),
	6: preload("res://assets/tetrominos/t.png"),
	7: preload("res://assets/tetrominos/s.png"),
	8: preload("res://assets/tetrominos/z.png"),
}


func _init(shp, tl = {"row": 0, "col": 3}):
	self.shape = shp.duplicate(true)
	self.topleft = tl.duplicate(true)
	self.def_topleft = topleft.duplicate(true)
	
	
func copy():
	var t = get_script().new(self.shape.duplicate(true), self.topleft.duplicate(true))
	return t


func rotated_right():
	var newft = self.copy()
	var newshape = []
	for x in range(len(self.shape[0])):
		newshape.append([])
		for y in range(len(self.shape)):
			newshape[x].push_front(self.shape[y][x])
	newft.shape = newshape
	return newft


func rotated_left():
	var newft = self.copy()
	var newshape = []
	for x in range(len(self.shape[0])):
#		x = len(self.shape[0]) -1 -x
		newshape.append([])
		for y in range(len(self.shape)):
			y = len(self.shape) - y - 1
			newshape[x].push_front(self.shape[y][len(self.shape[0]) -1 -x])
	newft.shape = newshape
	return newft


func moved_left():
	var newft = self.copy()
	newft.topleft.col -= 1
	return newft


func moved_right():
	var newft = self.copy()
	newft.topleft.col += 1
	return newft


func moved_down():
	var newft = self.copy()
	newft.topleft.row += 1
	return newft

func containsPoint(x: int, y: int):
	return (y in range(topleft.row, topleft.row+len(shape)) and x in range(topleft.col, topleft.col+len(shape[0])))

func valueAtPoint(x: int, y: int):
	if containsPoint(x, y):
		return shape[y - topleft.row][x - topleft.col]
	else :
		return -1

static func get_tint_from_value(value):
	return colors[value]


static func get_texture_from_value(value):
	return textures[value]


func reset_topleft():
	var new_topleft = self.def_topleft.duplicate(true)
	self.topleft = new_topleft
