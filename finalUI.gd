extends Control

const LEVEL1_SCENE := preload("res://level1.tscn")

func _ready():
	$Dimmer/Panel/VBoxContainer/HBoxContainer/PlayAgainButton.pressed.connect(_on_play_again_pressed)
	$Dimmer/Panel/VBoxContainer/HBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_play_again_pressed():
	get_tree().change_scene_to_packed(LEVEL1_SCENE)

func _on_quit_pressed():
	get_tree().quit()
