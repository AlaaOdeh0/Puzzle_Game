extends Control
signal next_level

var btn_original_color := Color.WHITE  # store the original color

func _ready():
	var btn = $Panel/VBoxContainer/NextLevelButton
	
	# store original font color
	btn_original_color = btn.get_theme_color("font_color", "Button")
	
	# connect signals
	btn.pressed.connect(_on_next_level_button_pressed)
	btn.mouse_entered.connect(_on_next_level_button_mouse_entered)
	btn.mouse_exited.connect(_on_next_level_button_mouse_exited)

func _on_next_level_button_pressed():
	# بدل الإشارة → حمل مشهد level2
	get_tree().change_scene_to_file("res://level2.tscn")

func _on_next_level_button_mouse_entered():
	var btn = $Panel/VBoxContainer/NextLevelButton
	btn.pivot_offset = btn.size / 2  # scale from center
	btn.add_theme_color_override("font_color", Color("#00002B"))  # hover text color
	var tw = create_tween()
	tw.tween_property(btn, "scale", Vector2(0.86, 0.86), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_next_level_button_mouse_exited():
	var btn = $Panel/VBoxContainer/NextLevelButton
	btn.pivot_offset = btn.size / 2
	btn.add_theme_color_override("font_color", btn_original_color)  # restore original color
	var tw = create_tween()
	tw.tween_property(btn, "scale", Vector2(1, 1), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
