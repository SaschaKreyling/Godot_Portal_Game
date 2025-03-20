extends AudioStreamPlayer3D


var voice_lines = [
	preload("res://assets/voice_lines/not inspired by aperture.wav"),
	preload("res://assets/voice_lines/not inspired by Portal.wav"),
	preload("res://assets/voice_lines/we care about profits.wav"),
	preload("res://assets/voice_lines/we dont care about you.wav"),
	preload("res://assets/voice_lines/Welcome to warpurtre science.wav")
	]

func _init() -> void:
	var random_index : int = randi_range(0,voice_lines.size()-1) 
	var voice_line : AudioStream = voice_lines[random_index]
	stream = voice_line

func _ready() -> void:
	play()
