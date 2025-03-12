extends AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var voice_lines : Array = DirAccess.get_files_at("res://assets/voice_lines/")
	voice_lines = voice_lines.filter(isDotWav)
	var random_index = randi_range(0,voice_lines.size()-1) 
	var voice_line = load("res://assets/voice_lines/" + voice_lines[random_index])
	stream = voice_line
	play()

func isDotWav(file) -> bool:
	return file.ends_with(".wav")
