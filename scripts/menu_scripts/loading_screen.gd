extends Control

var loadingString : String = "LOADING"
var count = 0
@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel

func _process(delta: float) -> void:
	if count < 25:
		rich_text_label.text += loadingString
		count += 1
