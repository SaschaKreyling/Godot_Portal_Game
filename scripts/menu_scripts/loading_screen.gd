extends Control

var loading_string : String = "LOADING"
var count = 0
@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel

func _process(_delta: float) -> void:
	if count < 25:
		rich_text_label.text += loading_string
		count += 1
