extends Control

@onready var aiText: RichTextLabel = $PanelContainer/VBoxContainer/RichTextLabel
@onready var textEdit: TextEdit = $PanelContainer/VBoxContainer/TextEdit
@onready var Chat = $NobodyWhoChat

var _buffer := ""

func _ready() -> void:
	if Chat:
		if not Chat.is_connected("response_updated", Callable(self, "_on_response_updated")):
			Chat.connect("response_updated", Callable(self, "_on_response_updated"))
		if not Chat.is_connected("response_finished", Callable(self, "_on_response_finished")):
			Chat.connect("response_finished", Callable(self, "_on_response_finished"))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_newline"):
		_send()

func _send() -> void:
	var msg := textEdit.text.strip_edges()
	if msg == "":
		return
	textEdit.editable = false
	aiText.text += "\nYou: " + msg + "\n"
	_buffer = ""
	Chat.say(msg)

func _on_response_updated(tok: String) -> void:
	_buffer += tok

func _on_response_finished(response: String) -> void:
	aiText.text += "AI: " + response + "\n"
	textEdit.text = ""
	textEdit.editable = true
