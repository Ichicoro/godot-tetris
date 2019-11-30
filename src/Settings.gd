extends Node

enum EDITABLES \
{
	MUSIC,
	SFX
}

const min_difficulty: int = 1
const max_difficulty: int = 20

var canPlayMusic : bool = true
var canPlaySFX : bool = true

func reset():
	canPlayMusic = true
	canPlaySFX = true
	
func setValue(id, val):
	match id:
		EDITABLES.MUSIC : canPlayMusic = val
		EDITABLES.SFX : canPlaySFX = val
		
func getValue(id):
	match id:
		EDITABLES.MUSIC : return canPlayMusic
		EDITABLES.SFX : return canPlaySFX
