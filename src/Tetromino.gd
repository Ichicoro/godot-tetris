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


func _init(shape, topleft = {"row": 0, "col": 3}):
	self.shape = shape.duplicate(true)
	self.topleft = topleft.duplicate(true)
	self.def_topleft = topleft.duplicate(true)
	
	
func copy():
	var t = get_script().new(self.shape.duplicate(true), self.topleft.duplicate(true))
	return t


func rotated_right():
	return self.shape


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


static func get_tint_from_value(value):
	return colors[value]


func reset_topleft():
	self.topleft = self.def_topleft.duplicate(true)