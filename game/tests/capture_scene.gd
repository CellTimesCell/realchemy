extends SceneTree
## Dev helper: open a scene, place the hero, optionally play a reaction, and
## save viewport screenshots. Needs a window (not --headless).
## Usage (user args after --):
##   scene=res://... out=C:/path/shot.png hero=x,y wait=30
##   [react=scratch_head] [shots=6] [step=6] [scale=2] [call=Props/Node:method]
##   [tex=Props/A/Sprite>res://a.png;Props/B/Sprite>res://b.png] (swap textures)
##   [face=east|west|north|south] [input=ui_accept] [key=I] (pressed after wait)

var _args: Dictionary = {}


func _initialize() -> void:
	for arg: String in OS.get_cmdline_user_args():
		var parts: PackedStringArray = arg.split("=", true, 1)
		if parts.size() == 2:
			_args[parts[0]] = parts[1]
	_run.call_deferred()


func _run() -> void:
	var scene: Node = (load(_args["scene"]) as PackedScene).instantiate()
	root.add_child(scene)
	var hero: Node2D = scene.get_node_or_null("Hero") as Node2D
	if hero and _args.has("hero"):
		var xy: PackedStringArray = (_args["hero"] as String).split(",")
		hero.position = Vector2(float(xy[0]), float(xy[1]))
	if _args.has("tex"):
		for pair: String in (_args["tex"] as String).split(";"):
			var kv: PackedStringArray = pair.split(">")
			(scene.get_node(kv[0]) as Sprite2D).texture = load(kv[1])
	for i: int in int(_args.get("wait", "30")):
		await process_frame
	if _args.has("call"):
		var target: PackedStringArray = (_args["call"] as String).split(":")
		scene.get_node(target[0]).call(target[1])
	if hero and _args.get("hidehero", "0") == "1":
		hero.visible = false
	if hero and _args.has("face"):
		hero.set("_facing", _args["face"])
		hero.call("_update_animation", Vector2.ZERO)
		for i: int in 2:
			await process_frame
	if _args.has("input"):
		_press_action(_args["input"])
	if _args.has("key"):
		_press_key(OS.find_keycode_from_string(_args["key"]))
	if hero and _args.has("react"):
		hero.play_reaction(_args["react"])
	var shots: int = int(_args.get("shots", "1"))
	var step: int = int(_args.get("step", "6"))
	var out: String = _args["out"]
	for shot: int in shots:
		for i: int in step:
			await process_frame
		var image: Image = root.get_texture().get_image()
		var scale: int = int(_args.get("scale", "1"))
		if scale > 1:
			image.resize(image.get_width() * scale, image.get_height() * scale, Image.INTERPOLATE_NEAREST)
		var path: String = out if shots == 1 else out.replace(".png", "_%02d.png" % shot)
		image.save_png(path)
	quit()


func _press_action(action: String) -> void:
	for pressed: bool in [true, false]:
		var event: InputEventAction = InputEventAction.new()
		event.action = action
		event.pressed = pressed
		Input.parse_input_event(event)


func _press_key(keycode: Key) -> void:
	for pressed: bool in [true, false]:
		var event: InputEventKey = InputEventKey.new()
		event.physical_keycode = keycode
		event.keycode = keycode
		event.pressed = pressed
		Input.parse_input_event(event)
