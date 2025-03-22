extends Node

signal portal_quality_updated
signal voice_volume_changed  
signal surrounding_volume_changed

var voice_volume : float = 1
var surrounding_volume : float = 1
var portal_quality : float = 0.9

func set_voice_volume(value : float):
	voice_volume_changed.emit()
	voice_volume = clampf(value, 0, 1)

func get_voice_volume() -> float:
	return voice_volume

func set_surrounding_volume(value : float):
	surrounding_volume_changed.emit()
	surrounding_volume = clampf(value, 0, 1)

func get_surrounding_volume() -> float:
	return surrounding_volume

func set_portal_quality_scale(value : float):
	portal_quality_updated.emit()
	portal_quality = clampf(value, 0, 1)

func get_portal_quality_scale() -> float:
	return portal_quality
