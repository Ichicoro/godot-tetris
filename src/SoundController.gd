extends Node

export(float, 0.0, 3.0, 0.1) var delay = 2.0
export(String, DIR) var sfxDir = "res://assets/sounds/sfx"

onready var sfx = $SFXPlayer
onready var music = $MusicPlayer

var sfxQueue = []

var playableActions = \
[
	Table.TABLE_ACTION.HARD_DROP
]

func _ready():
	yield(get_tree().create_timer(delay), "timeout")
	music.play()
	
func _process(delta):
	if not sfx.playing and not sfxQueue.empty():
		playNextSFX()
	
func queueSFX(action) :
	
	if playableActions.has(action) :
		
		if not sfxQueue.has(action) :
			sfxQueue.append(action)
			
		playNextSFX()

func getFileForAction(action) :
	
	var actionStr = Table.tableActionToString(action)
	return sfxDir + "/" + actionStr + ".wav"

func toggleMusicPaused(pause):
	
	music.stream_paused = pause

func playNextSFX():
	var action = sfxQueue.pop_front()
	var fileName = getFileForAction(action)
	sfx.stream = load(fileName)
	sfx.play()
