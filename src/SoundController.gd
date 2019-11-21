extends Node

export(float, 0.0, 3.0, 0.1) var delay = 2.0
export(String, DIR) var sfxDir = "res://assets/sounds/sfx"

onready var sfx = $SFXPlayer
onready var music = $MusicPlayer

var playableActions = \
[
	Table.TABLE_ACTION.HARD_DROP
]

func _ready():
	yield(get_tree().create_timer(delay), "timeout")
	music.play()
	
func playSFX(action) :
	
	if playableActions.has(action) :
	
		var actionStr = Table.tableActionToString(action)
		var fileName = sfxDir + "/" + actionStr + ".wav"
		
		sfx.stream = load(fileName)
		sfx.play()
