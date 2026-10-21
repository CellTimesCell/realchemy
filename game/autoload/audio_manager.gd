extends Node
## Sound effects by name. Names map to files in SFX_DIR (placeholders until
## T-27). play_sfx() picks a free player from a small pool, so short sounds
## can overlap. Unknown names are ignored with a warning.

const SFX_DIR: String = "res://assets/audio/sfx_placeholder/"
const POOL_SIZE: int = 6
const SFX: Dictionary = {
	"open": "open.wav",
	"close": "close.wav",
	"locked": "locked.wav",
	"pickup": "pickup.wav",
	"creak": "creak.wav",
	"chirp": "canary_chirp.wav",
	"spray": "spray.wav",
	"squeak": "squeak.wav",
}

var _streams: Dictionary = {}
var _pool: Array[AudioStreamPlayer] = []


func _ready() -> void:
	for sfx_name: String in SFX:
		var path: String = SFX_DIR + SFX[sfx_name]
		if ResourceLoader.exists(path):
			_streams[sfx_name] = load(path)
	for i: int in POOL_SIZE:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(player)
		_pool.append(player)


func has_sfx(sfx_name: String) -> bool:
	return _streams.has(sfx_name)


func play_sfx(sfx_name: String, pitch: float = 1.0) -> void:
	if sfx_name.is_empty():
		return
	if not _streams.has(sfx_name):
		push_warning("AudioManager: no sfx '%s'" % sfx_name)
		return
	var player: AudioStreamPlayer = _pool[0]
	for candidate: AudioStreamPlayer in _pool:
		if not candidate.playing:
			player = candidate
			break
	player.stream = _streams[sfx_name]
	player.pitch_scale = pitch
	player.play()
