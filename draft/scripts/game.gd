extends Node2D
## Draft prototype of Bounce Back. Rectangles only.
## Follows STORY.md. Not the Haven submission.

enum Mode { TITLE, PLAY, TALK, BAR, FALL, END }

const SPEED := 110.0
const REACH := 34.0

var mode := Mode.TITLE
var room := "house"
var bar_kind := "exam"
var bar_pos := 0.0
var bar_dir := 1.0
var bar_speed := 0.55
var green_center := 0.5
var green_half := 0.16
var mash := 0.0
var space_held := false
var shake := 0.0
var lines: Array = []
var line_i := 0
var after_talk := ""

var got_up := false
var got_mirror := false
var got_shoes := false
var got_bag := false
var got_mom := false
var exam_done := false
var paper_count := 0
var papers_done := false
var creative_done := false
var thoughts_started := false
var thoughts_done := false
var ended := false

var world: Node2D
var modulate_node: CanvasModulate
var player: CharacterBody2D
var player_body: Polygon2D
var rooms := {}
var kabir: Node2D
var phone: Node2D

var talk_box: Panel
var talk_label: Label
var bar_root: Control
var green_zone: ColorRect
var marker: ColorRect
var fall_root: Control
var mash_fill: ColorRect
var title_root: Control
var end_root: Control
var objective: Label
var prompt: Label
var hc_label: Label


func _ready() -> void:
	modulate_node = CanvasModulate.new()
	add_child(modulate_node)
	world = Node2D.new()
	world.name = "World"
	add_child(world)
	_build_rooms()
	_build_player()
	_build_ui()
	_show_room("house")
	player.visible = false
	_apply_mode()


func _physics_process(delta: float) -> void:
	if mode != Mode.PLAY:
		player.velocity = Vector2.ZERO
		return
	var dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		dir.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		dir.x += 1
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		dir.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		dir.y += 1
	player.velocity = dir.normalized() * SPEED
	player.move_and_slide()


func _process(delta: float) -> void:
	var down := Input.is_key_pressed(KEY_SPACE)
	var pressed := down and not space_held
	space_held = down
	if mode == Mode.BAR:
		bar_pos += bar_dir * bar_speed * delta
		if bar_pos >= 1.0:
			bar_pos = 1.0
			bar_dir = -1.0
		elif bar_pos <= 0.0:
			bar_pos = 0.0
			bar_dir = 1.0
		marker.position.x = bar_pos * 200.0
		if pressed:
			_resolve_bar(abs(bar_pos - green_center) <= green_half)
	elif mode == Mode.FALL and pressed:
		mash = min(1.0, mash + 0.17)
		mash_fill.size.x = 200.0 * mash
		if mash >= 1.0:
			_stand_up()
	elif pressed:
		_on_confirm()
	if shake > 0.0:
		shake = max(0.0, shake - delta)
		world.position = Vector2(randf_range(-2, 2), randf_range(-1, 1))
	else:
		world.position = Vector2.ZERO
	_refresh_prompt()


func _on_confirm() -> void:
	match mode:
		Mode.TITLE:
			mode = Mode.PLAY
			player.visible = true
			_apply_mode()
		Mode.TALK:
			_advance_talk()
		Mode.END:
			get_tree().reload_current_scene()
		Mode.PLAY:
			var node := _nearest()
			if node:
				_use(str(node.get_meta("id")))


func _use(id: String) -> void:
	match id:
		"bed":
			if got_up:
				return
			got_up = true
			start_talk([{"who": "Arun", "text": "Up. Not late yet."}], "")
		"mirror":
			if not got_up or got_mirror:
				return
			got_mirror = true
			start_talk([{"who": "Arun", "text": "Don't lie again today."}], "")
		"shoes":
			if not got_up or got_shoes:
				return
			got_shoes = true
		"bag":
			if not got_up or got_bag:
				return
			got_bag = true
			start_talk([{"who": "Arun", "text": "Still empty. She thinks I revised."}], "")
		"mom":
			if not got_up or got_mom:
				return
			got_mom = true
			start_talk([
				{"who": "Mom", "text": "You studied?"},
				{"who": "Arun", "text": "I'm going."},
				{"who": "Mom", "text": "Eat on the way. And come home."},
			], "")
		"door_school":
			if got_mirror and got_shoes and got_bag and got_mom:
				_enter("school")
			else:
				start_talk([{"who": "Arun", "text": "Mirror, shoes, bag, and Mom. Then I go."}], "")
		"board":
			if not exam_done:
				kabir.visible = true
				start_talk([
					{"who": "Ms. Das", "text": "One question. The one from last night's page."},
					{"who": "Arun", "text": "The page I never opened."},
					{"who": "Arun", "text": "It's gone. There's nothing there."},
					{"who": "Kabir", "text": "I went blank in this room last year."},
					{"who": "Kabir", "text": "Stand up and say one answer. A bad one still counts."},
				], "exam_bar")
			elif not papers_done:
				start_talk([{"who": "Ms. Das", "text": "Those, on my desk."}], "")
			elif not creative_done:
				start_talk([
					{"who": "Ms. Das", "text": "One sentence. What is this about?"},
					{"who": "Arun", "text": "They're all looking."},
					{"who": "Kabir", "text": "Don't perform. Point at one true thing."},
				], "creative_bar")
			else:
				start_talk([{"who": "Ms. Das", "text": "Results tonight. Go home."}], "")
		"paper1", "paper2", "paper3":
			if not exam_done or papers_done:
				return
			var node: Node = rooms["school"].get_node(NodePath(id))
			node.visible = false
			paper_count += 1
			if paper_count == 2:
				start_talk([{"who": "Arun", "text": "Last week they laughed. Keep walking."}], "")
		"desk":
			if paper_count < 3 or papers_done:
				return
			papers_done = true
			start_talk([
				{"who": "Ms. Das", "text": "Leave them. Now the picture."},
				{"who": "Ms. Das", "text": "One sentence. What is this about?"},
				{"who": "Arun", "text": "They're all looking."},
				{"who": "Kabir", "text": "Don't perform. Point at one true thing."},
			], "creative_bar")
		"door_home":
			if creative_done:
				_enter("roof")
			else:
				start_talk([{"who": "Arun", "text": "Not until the picture is done."}], "")
		"phone":
			if thoughts_done and not ended:
				ended = true
				start_talk([
					{"who": "Phone", "text": "PASSED"},
					{"who": "Arun", "text": "Not first. Passed."},
				], "ending")


func start_talk(pack: Array, then: String) -> void:
	lines = pack
	line_i = 0
	after_talk = then
	mode = Mode.TALK
	_show_line()
	_apply_mode()


func _advance_talk() -> void:
	line_i += 1
	if line_i >= lines.size():
		var nxt := after_talk
		after_talk = ""
		mode = Mode.PLAY
		_apply_mode()
		_after(nxt)
	else:
		_show_line()


func _after(nxt: String) -> void:
	match nxt:
		"exam_bar":
			_open_bar("exam")
		"creative_bar":
			_open_bar("creative")
		"thoughts_done":
			thoughts_done = true
			phone.visible = true
		"ending":
			mode = Mode.END
			_apply_mode()
		_:
			pass


func _open_bar(kind: String) -> void:
	bar_kind = kind
	bar_pos = 0.0
	bar_dir = 1.0
	if kind == "exam":
		bar_speed = 0.55
		green_center = 0.5
		green_half = 0.16
	else:
		bar_speed = 0.9
		green_center = 0.62
		green_half = 0.09
	var track_w := 220.0
	var zone_w := green_half * 2.0 * track_w
	green_zone.position.x = green_center * track_w - zone_w * 0.5
	green_zone.size.x = zone_w
	mode = Mode.BAR
	_apply_mode()


func _resolve_bar(hit: bool) -> void:
	if not hit:
		mash = 0.0
		mash_fill.size.x = 0
		shake = 0.28
		modulate_node.color = Color(0.45, 0.45, 0.48)
		player_body.color = Color(0.35, 0.4, 0.45)
		mode = Mode.FALL
		_apply_mode()
		return
	modulate_node.color = Color.WHITE
	player_body.color = Color(0.95, 0.72, 0.35)
	if bar_kind == "exam":
		exam_done = true
		start_talk([
			{"who": "Arun", "text": "It's the second one. I think."},
			{"who": "Ms. Das", "text": "Sit. We're moving on."},
		], "")
	else:
		creative_done = true
		start_talk([
			{"who": "Arun", "text": "Somebody left, and the room stayed."},
			{"who": "Ms. Das", "text": "That's a sentence. Bell's about to go."},
		], "")


func _stand_up() -> void:
	modulate_node.color = Color.WHITE
	player_body.color = Color(0.95, 0.72, 0.35)
	var nxt := "exam_bar" if bar_kind == "exam" else "creative_bar"
	start_talk([{"who": "Kabir", "text": "Again."}], nxt)


func _enter(next: String) -> void:
	room = next
	_show_room(next)
	match next:
		"school":
			player.position = Vector2(240, 210)
		"roof":
			player.position = Vector2(240, 200)
			if not thoughts_started:
				thoughts_started = true
				start_talk([
					{"who": "Arun", "text": "I told her I revised."},
					{"who": "Arun", "text": "I froze, and then I didn't."},
					{"who": "Arun", "text": "If this says fail, I stay the kid who can't get up."},
				], "thoughts_done")
		_:
			player.position = Vector2(80, 80)


func _show_room(which: String) -> void:
	for key in rooms:
		rooms[key].visible = key == which


func _nearest() -> Node:
	var best: Node = null
	var best_d := REACH
	var folder: Node = rooms[room]
	for node in get_tree().get_nodes_in_group("use"):
		if not node.visible:
			continue
		if node.get_parent() != folder:
			continue
		var d := player.global_position.distance_to(node.global_position)
		if d < best_d:
			best_d = d
			best = node
	return best


func _refresh_prompt() -> void:
	if objective:
		objective.text = _objective_text()
	if prompt == null:
		return
	if mode != Mode.PLAY:
		prompt.text = ""
		return
	var node := _nearest()
	prompt.text = "Space" if node else ""


func _objective_text() -> String:
	if mode == Mode.TITLE or mode == Mode.END:
		return ""
	if room == "house":
		if not got_up:
			return "Get up"
		var missing: PackedStringArray = []
		if not got_mirror:
			missing.append("mirror")
		if not got_shoes:
			missing.append("shoes")
		if not got_bag:
			missing.append("bag")
		if not got_mom:
			missing.append("Mom")
		if missing.size() > 0:
			return "Get ready: " + ", ".join(missing)
		return "Leave for school"
	if room == "school":
		if not exam_done:
			return "The question on the board"
		if not papers_done:
			return "Papers %d/3, then the desk" % paper_count
		if not creative_done:
			return "One sentence about the picture"
		return "Go home"
	if not thoughts_done:
		return "The roof"
	return "Open the phone"


func _show_line() -> void:
	var row: Dictionary = lines[line_i]
	talk_label.text = "%s: %s" % [row["who"], row["text"]]


func _apply_mode() -> void:
	talk_box.visible = mode == Mode.TALK
	bar_root.visible = mode == Mode.BAR
	fall_root.visible = mode == Mode.FALL
	title_root.visible = mode == Mode.TITLE
	end_root.visible = mode == Mode.END
	hc_label.visible = mode == Mode.PLAY or mode == Mode.BAR or mode == Mode.FALL
	objective.visible = mode == Mode.PLAY or mode == Mode.TALK or mode == Mode.BAR or mode == Mode.FALL


func _build_rooms() -> void:
	rooms["house"] = _room("house", Color(0.16, 0.18, 0.28))
	rooms["school"] = _room("school", Color(0.36, 0.33, 0.26))
	rooms["roof"] = _room("roof", Color(0.18, 0.14, 0.28))
	_dress_house()
	_dress_school()
	_dress_roof()


func _room(room_name: String, floor_color: Color) -> Node2D:
	var folder := Node2D.new()
	folder.name = room_name
	world.add_child(folder)
	var floor := _poly(Vector2(480, 270), floor_color)
	floor.position = Vector2(240, 135)
	folder.add_child(floor)
	_wall(folder, Vector2(240, 10), Vector2(480, 20))
	_wall(folder, Vector2(240, 260), Vector2(480, 20))
	_wall(folder, Vector2(10, 135), Vector2(20, 270))
	_wall(folder, Vector2(470, 135), Vector2(20, 270))
	return folder


func _dress_house() -> void:
	var h: Node2D = rooms["house"]
	_use_node(h, "bed", Vector2(90, 70), Color(0.45, 0.28, 0.22), Vector2(64, 36))
	_use_node(h, "mirror", Vector2(70, 150), Color(0.55, 0.75, 0.85), Vector2(22, 36))
	_use_node(h, "bag", Vector2(200, 90), Color(0.75, 0.45, 0.2), Vector2(22, 18))
	_use_node(h, "shoes", Vector2(300, 180), Color(0.25, 0.18, 0.14), Vector2(26, 12))
	_use_node(h, "mom", Vector2(380, 80), Color(0.7, 0.28, 0.32), Vector2(16, 28))
	_use_node(h, "door_school", Vector2(240, 230), Color(0.85, 0.7, 0.3), Vector2(36, 16))
	_tag(h, Vector2(16, 28), "House")


func _dress_school() -> void:
	var s: Node2D = rooms["school"]
	_use_node(s, "board", Vector2(240, 48), Color(0.2, 0.35, 0.45), Vector2(120, 28))
	_use_node(s, "desk", Vector2(240, 100), Color(0.55, 0.4, 0.28), Vector2(50, 16))
	_blob(s, Vector2(200, 78), Vector2(14, 26), Color(0.25, 0.4, 0.55))
	kabir = _blob(s, Vector2(300, 110), Vector2(14, 26), Color(0.45, 0.3, 0.6))
	kabir.visible = false
	_use_node(s, "paper1", Vector2(90, 160), Color(0.9, 0.9, 0.85), Vector2(14, 10))
	_use_node(s, "paper2", Vector2(180, 180), Color(0.9, 0.9, 0.85), Vector2(14, 10))
	_use_node(s, "paper3", Vector2(330, 160), Color(0.9, 0.9, 0.85), Vector2(14, 10))
	_use_node(s, "door_home", Vector2(400, 220), Color(0.85, 0.7, 0.3), Vector2(36, 16))
	_tag(s, Vector2(16, 28), "School")


func _dress_roof() -> void:
	var r: Node2D = rooms["roof"]
	_wall(r, Vector2(240, 48), Vector2(200, 10))
	phone = _use_node(r, "phone", Vector2(240, 140), Color(0.1, 0.1, 0.12), Vector2(16, 26))
	phone.visible = false
	_tag(r, Vector2(16, 28), "Roof")


func _build_player() -> void:
	player = CharacterBody2D.new()
	player.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	player.position = Vector2(90, 110)
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(14, 14)
	shape.shape = rect
	player.add_child(shape)
	player_body = _poly(Vector2(14, 20), Color(0.95, 0.72, 0.35))
	player.add_child(player_body)
	world.add_child(player)


func _build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(root)

	hc_label = _label(root, "HC", Vector2(8, 6), 14)
	objective = _label(root, "", Vector2(8, 248), 12)
	prompt = _label(root, "", Vector2(400, 248), 12)

	talk_box = Panel.new()
	talk_box.position = Vector2(16, 190)
	talk_box.size = Vector2(448, 52)
	root.add_child(talk_box)
	talk_label = _label(talk_box, "", Vector2(8, 8), 14)
	talk_label.size = Vector2(432, 36)
	talk_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	bar_root = Control.new()
	bar_root.position = Vector2(130, 150)
	bar_root.size = Vector2(220, 28)
	root.add_child(bar_root)
	var track := ColorRect.new()
	track.color = Color(0.1, 0.1, 0.12)
	track.size = Vector2(220, 16)
	bar_root.add_child(track)
	green_zone = ColorRect.new()
	green_zone.color = Color(0.3, 0.7, 0.4)
	green_zone.size = Vector2(40, 16)
	track.add_child(green_zone)
	marker = ColorRect.new()
	marker.color = Color(0.95, 0.95, 0.9)
	marker.size = Vector2(4, 16)
	track.add_child(marker)
	var bar_hint := _label(bar_root, "Space in the green", Vector2(0, 16), 11)
	bar_hint.modulate = Color(1, 1, 1, 0.9)

	fall_root = Control.new()
	fall_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(fall_root)
	fall_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.35)
	fall_root.add_child(dim)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	var mash_track := ColorRect.new()
	mash_track.color = Color(0.1, 0.1, 0.12)
	mash_track.position = Vector2(130, 120)
	mash_track.size = Vector2(200, 14)
	fall_root.add_child(mash_track)
	mash_fill = ColorRect.new()
	mash_fill.color = Color(0.9, 0.75, 0.3)
	mash_fill.size = Vector2(0, 14)
	mash_track.add_child(mash_fill)
	_label(fall_root, "He fell. Mash Space.", Vector2(130, 98), 14)

	title_root = Control.new()
	root.add_child(title_root)
	title_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	var title_bg := ColorRect.new()
	title_bg.color = Color(0.08, 0.08, 0.12)
	title_root.add_child(title_bg)
	title_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label(title_root, "HC", Vector2(24, 28), 28)
	_label(title_root, "Hack Club Haven", Vector2(24, 64), 14)
	_label(title_root, "BOUNCE BACK", Vector2(24, 100), 28)
	_label(title_root, "Draft. Not the jam build.", Vector2(24, 140), 14)
	_label(title_root, "Space to wake up", Vector2(24, 190), 14)

	end_root = Control.new()
	root.add_child(end_root)
	end_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	var end_bg := ColorRect.new()
	end_bg.color = Color(0.1, 0.08, 0.14, 0.92)
	end_root.add_child(end_bg)
	end_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label(end_root, "He passed.", Vector2(24, 80), 28)
	_label(end_root, "Tomorrow he can tell Mom the truth.", Vector2(24, 120), 16)
	_label(end_root, "HC — Hack Club Haven", Vector2(24, 170), 14)
	_label(end_root, "Space for the title", Vector2(24, 210), 12)


func _wall(parent: Node, center: Vector2, size: Vector2) -> void:
	var body := StaticBody2D.new()
	body.position = center
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.add_child(shape)
	body.add_child(_poly(size, Color(0.12, 0.1, 0.14)))
	parent.add_child(body)


func _use_node(parent: Node, id: String, center: Vector2, color: Color, size: Vector2) -> Node2D:
	var node := Node2D.new()
	node.name = id
	node.position = center
	node.set_meta("id", id)
	node.add_to_group("use")
	node.add_child(_poly(size, color))
	parent.add_child(node)
	return node


func _blob(parent: Node, center: Vector2, size: Vector2, color: Color) -> Node2D:
	var node := Node2D.new()
	node.position = center
	node.add_child(_poly(size, color))
	parent.add_child(node)
	return node


func _poly(size: Vector2, color: Color) -> Polygon2D:
	var poly := Polygon2D.new()
	poly.color = color
	var half := size * 0.5
	poly.polygon = PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x, half.y),
		Vector2(-half.x, half.y),
	])
	return poly


func _tag(parent: Node, pos: Vector2, text: String) -> void:
	var lab := _label(parent, text, pos, 14)
	lab.modulate = Color(1, 1, 1, 0.85)


func _label(parent: Node, text: String, pos: Vector2, font_size: int) -> Label:
	var lab := Label.new()
	lab.text = text
	lab.position = pos
	lab.add_theme_font_size_override("font_size", font_size)
	parent.add_child(lab)
	return lab
