extends Node

export(float, 0.0, 3.0, 0.1) var delay = 2.0
export(String, DIR) var sfxDir = "res://assets/sounds/sfx"

onready var sfx = $SFXPlayer
onready var music = $MusicPlayer

var sfxQueue = []

var playableActions = \
[
	Table.TABLE_ACTION.HARD_DROP,
	Table.TABLE_ACTION.SINGLE_CLEAR,
	Table.TABLE_ACTION.DOUBLE_CLEAR,
	Table.TABLE_ACTION.TRIPLE_CLEAR,
	Table.TABLE_ACTION.TETRIS,
	Table.TABLE_ACTION.LEVEL_UP
]

func _ready():
	yield(get_tree().create_timer(delay), "timeout")
	music.play()
	
func queueSFX(action) :
	
	if playableActions.has(action) :
		
		if not sfxQueue.has(action) :
			sfxQueue.append(action)
			
		playNextSFX()

func getFileForAction(action) :
	
	#TEMPORARY (in attesa di avere .wav apposta anche per queste azioni)
	if action == Table.TABLE_ACTION.DOUBLE_CLEAR or action == Table.TABLE_ACTION.TRIPLE_CLEAR :
		action = Table.TABLE_ACTION.SINGLE_CLEAR

	var actionStr = Table.tableActionToString(action)
	return sfxDir + "/" + actionStr + ".wav"

func toggleMusicPaused(pause):
	
	music.stream_paused = pause

func playNextSFX():
	
	if len(sfxQueue) > 0:
		var action = sfxQueue.pop_front()
		print(action)
		var fileName = getFileForAction(action)
		sfx.stream = load(fileName)
		sfx.play()
