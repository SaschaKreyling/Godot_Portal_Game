extends Node

var current_scene = null
var loading_screen_scene
var loading = false
var loading_path 

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	loading_screen_scene = load("res://menus/loading_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	if loading:
		var tempArray = []
		ResourceLoader.load_threaded_get_status(loading_path,tempArray)
		var progress : float = tempArray[0]
		if progress == 1:
			var scene : PackedScene  = ResourceLoader.load_threaded_get(loading_path)
			set_scene(scene)
			loading = false
			loading_path = null

func goto_scene_deferred():
	ResourceLoader.load_threaded_request(loading_path)
	set_scene(loading_screen_scene)
	loading = true
	
func goto_scene_no_loading_deffered():
	ResourceLoader.load_threaded_request(loading_path)
	loading = true
	
func goto_scene(path : String):
	loading_path = path
	call_deferred("goto_scene_deferred")

func goto_scene_no_loading(path : String):
	loading_path = path
	call_deferred("goto_scene_no_loading_deffered")

func set_scene(scene : PackedScene):
	current_scene.free()
	current_scene = scene.instantiate()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
