extends Node

var loading_screen_scene : PackedScene = preload("res://Menus/SceneTransitionAndLoading/loading_screen.tscn")

var loading : bool = false
var loading_path : String

var current_scene_node : Node = null

func _ready():
	var root = get_tree().get_root()
	current_scene_node = root.get_child(root.get_child_count() - 1)

func _process(_delta: float) -> void:
	var root = get_tree().get_root()
	current_scene_node = root.get_child(root.get_child_count() - 1)
	
	if loading:
		var tempArray = []
		ResourceLoader.load_threaded_get_status(loading_path, tempArray)
		var progress : float = tempArray[0]
		if progress == 1:
			var loaded_scene : PackedScene  = ResourceLoader.load_threaded_get(loading_path)
			set_scene.call_deferred(loaded_scene)
			loading = false
			loading_path = ""

func goto_scene_deferred():
	ResourceLoader.load_threaded_request(loading_path)
	set_scene.call_deferred(loading_screen_scene)
	loading = true
	
func goto_scene_no_loading_screen_deffered():
	ResourceLoader.load_threaded_request(loading_path)
	loading = true
	
func goto_scene(path : String):
	print(path)
	loading_path = path
	goto_scene_deferred.call_deferred()

func goto_scene_no_loading_screen(path : String):
	print(path)
	loading_path = path
	goto_scene_no_loading_screen_deffered.call_deferred()

func set_scene(scene : PackedScene):
	current_scene_node.free()
	current_scene_node = scene.instantiate()
	get_tree().get_root().add_child(current_scene_node)
	get_tree().set_current_scene(current_scene_node)	
