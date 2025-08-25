extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called when the button is pressed
func _on_button_pressed() -> void:
	var result = get_tree().change_scene_to_file("res://level1.tscn")
	if result != OK:
		push_error("Error: Could not load main.tscn - check the path")


func _on_ask_to_play_pressed() -> void:
	var err := get_tree().change_scene_to_file("res://chat.tscn")
	if err != OK:
		push_error("Error: Could not load chat.tscn - check the path")


func _on_exit_pressed() -> void:
	get_tree().quit()
