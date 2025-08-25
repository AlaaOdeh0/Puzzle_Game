extends Area2D

const CELL   := 250        # حجم الخلية
const COLS   := 4          # أعمدة الشبكة
const ROWS   := 2          # صفوف الشبكة
const ORIGIN := Vector2(125, 125)  # مركز أول خلية (يسار-فوق)

var tiles: Array[Node2D] = []
var solved: Array[Node2D] = []
var mouse: InputEventMouseButton = null
var has_won := false

func _ready() -> void:
	start_game()

# حوّل اندكس الشبكة إلى إحداثيات مركز الخلية
func index_to_pos(i: int) -> Vector2:
	var r := i / COLS
	var c := i % COLS
	return Vector2(ORIGIN.x + c * CELL, ORIGIN.y + r * CELL)

# حوّل إحداثيات إلى اندكس خلية في الشبكة (يرجع -1 إذا خارج الشبكة)
func pos_to_index(p: Vector2) -> int:
	var c := int(round((p.x - ORIGIN.x) / float(CELL)))
	var r := int(round((p.y - ORIGIN.y) / float(CELL)))
	if r < 0 or r >= ROWS or c < 0 or c >= COLS:
		return -1
	return r * COLS + c

func start_game() -> void:
	# جميع البلاطات (Tile8 هي الفارغة)
	tiles = [$Tile1, $Tile2, $Tile3, $Tile4, $Tile5, $Tile6, $Tile7, $Tile8]

	# تأكد إن الكل ظاهر وفوق الخلفية
	for t in tiles:
		t.visible = true
		t.z_index = 1

	# رص البلاطات على الحالة الصحيحة المعيارية (2×4) ثم خزّن الحل
	for i in range(tiles.size()):
		tiles[i].position = index_to_pos(i)
	solved = tiles.duplicate()

	# اخلط بحركات قانونية باستعمال البلاطة الفارغة
	shuffle_tiles()
	has_won = false

func shuffle_tiles() -> void:
	var previous := -1
	var previous_1 := -1
	for _i in range(500):
		var idx := randi() % tiles.size()
		if tiles[idx] != $Tile8 and idx != previous and idx != previous_1:
			var pos_idx := pos_to_index(tiles[idx].position)
			if pos_idx == -1:
				continue
			var r := pos_idx / COLS
			var c := pos_idx % COLS
			check_neighbours(r, c)
			previous_1 = previous
			previous = idx

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy := mouse
		mouse = null
		var pos_idx := pos_to_index(mouse_copy.position)
		if pos_idx == -1:
			return
		var r := pos_idx / COLS
		var c := pos_idx % COLS
		check_neighbours(r, c)

		# فوز؟
		if not has_won and tiles == solved:
			has_won = true
			get_tree().change_scene_to_file("res://winnerUI.tscn")

func check_neighbours(rows: int, cols: int) -> void:
	if rows < 0 or rows >= ROWS or cols < 0 or cols >= COLS:
		return
	var pos := rows * COLS + cols
	if pos < 0 or pos >= tiles.size():
		return

	var empty := false
	var done := false
	while not empty and not done:
		var cell_center := tiles[pos].position

		# تحت
		if rows < ROWS - 1:
			empty = find_empty(cell_center + Vector2(0, CELL), pos)
			if empty: break
		# فوق
		if rows > 0:
			empty = find_empty(cell_center + Vector2(0, -CELL), pos)
			if empty: break
		# يمين
		if cols < COLS - 1:
			empty = find_empty(cell_center + Vector2(CELL, 0), pos)
			if empty: break
		# شمال
		if cols > 0:
			empty = find_empty(cell_center + Vector2(-CELL, 0), pos)
			if empty: break

		done = true

func find_empty(world_pos: Vector2, src_index: int) -> bool:
	var dst_index := pos_to_index(world_pos)
	if dst_index == -1:
		return false
	# البلاطة الفارغة هي Tile8
	if tiles[dst_index] == $Tile8:
		swap_tiles(src_index, dst_index)
		return true
	return false

func swap_tiles(tile_src: int, tile_dst: int) -> void:
	# بدّل المواقع الفيزيائية
	var temp_pos := tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos
	# وبدّل المرجع داخل المصفوفة (مهم لمقارنة tiles == solved)
	var tmp := tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = tmp

func _input_event(_viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		mouse = event as InputEventMouseButton
