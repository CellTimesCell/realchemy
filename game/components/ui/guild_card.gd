class_name GuildCard
extends PanelContainer
## The adventurer's guild card: rank, INT / STR / DEX / WIT / LUCK with xp
## pips and a one-line meaning each, health and energy. Once the Handbook is
## found, the unlocked Codex facts are listed under it.

const PIP_FULL: String = "#"
const PIP_EMPTY: String = "."

var _column: VBoxContainer


func _ready() -> void:
	visible = false
	var box: StyleBoxFlat = StyleBoxFlat.new()
	box.bg_color = Color(0.1, 0.07, 0.05, 0.95)
	box.border_color = Color(0.85, 0.7, 0.4)
	box.set_border_width_all(1)
	box.set_content_margin_all(5)
	add_theme_stylebox_override("panel", box)
	_column = VBoxContainer.new()
	_column.add_theme_constant_override("separation", 2)
	add_child(_column)
	EventBus.stats_changed.connect(_rebuild)
	EventBus.codex_unlocked.connect(func(_id: String) -> void: _rebuild())


func open() -> void:
	_rebuild()
	visible = true


func close() -> void:
	visible = false


func _rebuild() -> void:
	if not is_node_ready():
		return
	for child: Node in _column.get_children():
		child.queue_free()
	var stats: HeroStats = GameManager.stats
	_column.add_child(Hud.make_label("%s  -  %s %s" % [tr("UI_GUILD_CARD"), tr("UI_RANK"), HeroStats.rank()]))
	_column.add_child(Hud.make_label("%s %d/%d   %s %d/%d" % [tr("UI_HEALTH"), stats.health, HeroStats.health_max(),
			tr("UI_ENERGY"), stats.energy, HeroStats.energy_max()]))
	var table: Dictionary = HeroStats.data().get("stats", {})
	for stat: String in HeroStats.order():
		var lvl: int = stats.level(stat)
		var pips: String = PIP_FULL.repeat(lvl) + PIP_EMPTY.repeat(int(HeroStats.data().get("max_level", 4)) - lvl)
		var row: Label = Hud.make_label("%-5s %d  %s  %s" % [tr(table[stat]["name_key"]), stats.value(stat), pips,
				tr(table[stat]["desc_key"])])
		_column.add_child(row)
	if GameManager.has_flag("has_handbook"):
		_column.add_child(Hud.make_label(tr("UI_CODEX")))
		if GameManager.codex.is_empty():
			_column.add_child(Hud.make_label("  -"))
		for entry: String in GameManager.codex:
			var line: Label = Hud.make_label("* %s: %s" % [ChemistryEngine.codex_title(entry), ChemistryEngine.codex_text(entry)])
			line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			line.custom_minimum_size = Vector2(230, 0)
			_column.add_child(line)
	reset_size()
