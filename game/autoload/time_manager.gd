extends Node
## Real-time processes (rust dissolving on the gate lock): each has Unix
## start / end timestamps, so it goes on while the game is closed and is
## simply finished on return (Cozy / Classic only help, never punish - GDD
## §5). When a process ends its reaction's on_finish_flags are set and
## EventBus.process_finished fires. Times are Unix seconds (CLAUDE.md §2).

const CHECK_EVERY: float = 0.5

## process id -> {"reaction", "item", "started_at", "ends_at", "done"}
var processes: Dictionary = {}
## Debug / tests: seconds added to the real clock.
var clock_offset: float = 0.0
var _check_left: float = 0.0


func now() -> float:
	return Time.get_unix_time_from_system() + clock_offset


func _process(delta: float) -> void:
	_check_left -= delta
	if _check_left > 0.0:
		return
	_check_left = CHECK_EVERY
	check()


## Starts a reaction as a process (instant ones finish on the next check).
func start_reaction(reaction_id: String, process_id: String, used_item: String = "") -> void:
	var seconds: int = ChemistryEngine.duration_for(reaction_id, GameManager.mode, used_item)
	var start: float = now()
	processes[process_id] = {
		"reaction": reaction_id, "item": used_item,
		"started_at": int(start), "ends_at": int(start) + seconds, "done": false,
	}
	EventBus.process_started.emit(process_id)
	check()


func is_running(process_id: String) -> bool:
	return processes.has(process_id) and not processes[process_id]["done"]


func is_done(process_id: String) -> bool:
	return processes.has(process_id) and processes[process_id]["done"]


## 0..1 (1 when done or unknown-but-finished).
func progress(process_id: String) -> float:
	if not processes.has(process_id):
		return 0.0
	var p: Dictionary = processes[process_id]
	var total: float = maxf(1.0, float(p["ends_at"] - p["started_at"]))
	return clampf((now() - float(p["started_at"])) / total, 0.0, 1.0)


func remaining(process_id: String) -> int:
	if not is_running(process_id):
		return 0
	return maxi(0, int(ceil(float(processes[process_id]["ends_at"]) - now())))


## Finishes every process whose time has come.
func check() -> void:
	for process_id: String in processes:
		var p: Dictionary = processes[process_id]
		if p["done"] or now() < float(p["ends_at"]):
			continue
		p["done"] = true
		var reaction: Dictionary = ChemistryEngine.get_reaction(p["reaction"])
		for flag: String in reaction.get("on_finish_flags", []):
			GameManager.set_flag(flag)
		GameManager.unlock_codex(reaction.get("codex", ""))
		EventBus.process_finished.emit(process_id)
		EventBus.autosave_requested.emit()


func clear() -> void:
	processes.clear()
	clock_offset = 0.0


func to_dict() -> Dictionary:
	return processes.duplicate(true)


func from_dict(data: Dictionary) -> void:
	processes = data.duplicate(true)
	check()
