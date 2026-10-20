extends SceneTree
## Dev helper (not committed): the six garderobe posters flat, x4, in a row.
func _initialize() -> void:
	_run.call_deferred()
func _run() -> void:
	var names: Array[String] = ["rotley", "buns", "squid", "bonjovial", "whitesnack", "deaf"]
	var colors: Array[Color] = [Color(0.92, 0.92, 0.95), Color(0.85, 0.12, 0.12), Color(0.75, 1, 0.95), Color(1, 0.55, 0.8), Color(0.12, 0.4, 0.1), Color(1, 0.95, 0.4)]
	var keys: Array[String] = ["ROTLEY", "BUNS", "SQUID", "BONJOVIAL", "WHITESNACK", "DEAF"]
	var bg: ColorRect = ColorRect.new()
	bg.color = Color(0.18, 0.15, 0.22)
	bg.size = Vector2(640, 360)
	root.add_child(bg)
	var font: Font = load("res://assets/fonts/press_start_2p/PressStart2P-Regular.ttf")
	for i: int in names.size():
		var p: Node2D = (load("res://components/wall_poster.gd") as GDScript).new()
		p.set("texture", load("res://assets/pending/garderobe/posters/poster_%s.png" % names[i]))
		var x: float = 8 + i * 105
		p.set("wall_quad", PackedVector2Array([Vector2(x, 100), Vector2(x + 96, 100), Vector2(x + 96, 226), Vector2(x, 226)]))
		p.set("wall_size", Vector2(64, 84))
		p.set("rect", Rect2(0, 0, 64, 84))
		p.set("title_top", "POSTER_%s_1" % keys[i])
		p.set("title_bottom", "POSTER_%s_2" % keys[i])
		p.set("title_font", font)
		p.set("title_color", colors[i])
		p.set("has_shadow", false)
		root.add_child(p)
	for i: int in 30:
		await process_frame
	root.get_texture().get_image().save_png(OS.get_cmdline_user_args()[0])
	quit()
