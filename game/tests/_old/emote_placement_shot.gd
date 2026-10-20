extends SceneTree
## Dev helper (not committed): every emote on the hero and the ghost, saved as
## one crop per icon. Args after --: out=C:/dir flip=0|1

const ICONS: Array[String] = ["exclaim", "double", "question", "dots", "sweat", "anger", "gloom", "sparkle", "swirl"]

var _args: Dictionary = {}


func _initialize() -> void:
	for arg: String in OS.get_cmdline_user_args():
		var parts: PackedStringArray = arg.split("=", true, 1)
		if parts.size() == 2:
			_args[parts[0]] = parts[1]
	_run.call_deferred()


func _run() -> void:
	var scene: Node = (load("res://scenes/rooms/princess_suite.tscn") as PackedScene).instantiate()
	root.add_child(scene)
	var hero: Node2D = scene.get_node("Hero")
	hero.position = Vector2(170, 320)
	hero.set_physics_process(false)
	var ghost: Node2D = scene.get_node("Props/Ghost")
	ghost.position = Vector2(250, 320)
	ghost.visible = true
	ghost.get_node("Anim").play("idle")
	var hero_anim: AnimatedSprite2D = hero.get_node("Anim")
	hero_anim.play("idle_south")
	hero_anim.flip_h = _args.get("flip", "0") == "1"
	for i: int in 40:
		await process_frame
	var icons: PackedStringArray = (_args["icons"] as String).split(",") if _args.has("icons") else PackedStringArray(ICONS)
	for icon: String in icons:
		(hero.get_node("Reactions").emote as Emote).show_emote(icon, 0.6)
		(ghost.get_node("Reactions").emote as Emote).show_emote(icon, 0.6)
		await create_timer(0.35).timeout
		var image: Image = root.get_texture().get_image()
		image.save_png("%s/%s.png" % [_args["out"], icon])
		await create_timer(0.6).timeout
	quit()
