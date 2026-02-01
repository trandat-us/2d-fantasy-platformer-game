extends Node

signal loading_scene_started
signal loading_scene_finished
signal loading_progress_updated(value: float)

const _LOADING_SCREEN_PACKED: PackedScene = preload("uid://cmjb5semlrt7j")

enum SceneTransitionType {
	PROGRESS,
	FADE
}

var is_loading_scene: bool
var loading_progress: float = 0.0

var _is_loading_resource: bool
var _loading_screen: LoadingScreen
var _loading_scene_file: String
var _scene_to_changed: Node
var _trans_type: SceneTransitionType
var _scene_data: Variant

func change_to_scene_file(
	scene_file: String, 
	change_from_scene: Node, 
	scene_data: Variant = null, 
	trans_type: SceneTransitionType = SceneTransitionType.PROGRESS
) -> void:
	if is_loading_scene:
		push_error("Already loading a scene: " + _loading_scene_file)
		return
	
	if not ResourceLoader.exists(scene_file):
		push_error("Scene file " + scene_file + " doesn't exist")
		return
	
	if not is_instance_valid(change_from_scene):
		push_error("Must attach a valid scene to change from")
		return
	
	_loading_scene_file = scene_file
	_scene_to_changed = change_from_scene
	_trans_type = trans_type
	_scene_data = scene_data
	is_loading_scene = true
	
	_add_loading_screen()

func _process(delta: float) -> void:
	if not _is_loading_resource:
		return
	
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(_loading_scene_file, progress)
	
	if progress.size() > 0:
		loading_progress = progress[0]
		loading_progress_updated.emit(loading_progress)
		
		if _trans_type == SceneTransitionType.PROGRESS:
			_loading_screen.update_progress_transition(loading_progress * 100)
	
	match status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_handle_loading_error("Invalid resource")
		ResourceLoader.THREAD_LOAD_FAILED:
			_handle_loading_error("Failed to load")
		ResourceLoader.THREAD_LOAD_LOADED:
			var loaded_scene := ResourceLoader.load_threaded_get(_loading_scene_file)
			if loaded_scene:
				_finish_loading_scene(loaded_scene)
			else:
				_handle_loading_error("Loaded scene is null")

func _add_loading_screen() -> void:
	_loading_screen = _LOADING_SCREEN_PACKED.instantiate()
	get_tree().root.add_child(_loading_screen)
	_loading_screen.start_loading_screen(_trans_type, _on_show_screen_finished)
	loading_scene_started.emit()

func _on_show_screen_finished():
	if _trans_type == SceneTransitionType.PROGRESS:
		await get_tree().create_timer(0.5).timeout
	
	_create_threaded_request()

func _on_hide_screen_finished():
	if is_instance_valid(_loading_screen):
		_loading_screen.queue_free()
	
	_cleanup()

func _create_threaded_request() -> void:
	var error := ResourceLoader.load_threaded_request(_loading_scene_file)
	if error != OK:
		_handle_loading_error("Failed to start loading: " + str(error))
		return
	
	_is_loading_resource = true

func _replace_loaded_scene(loaded_scene: PackedScene) -> void:
	var instance := loaded_scene.instantiate()
	
	if _scene_to_changed.has_method("cleanup_scene"):
		_scene_to_changed.cleanup_scene()
	
	_scene_to_changed.get_parent().add_child(instance)
	_scene_to_changed.queue_free()
	await _scene_to_changed.tree_exited
	
	if instance.has_method("init_scene"):
		instance.init_scene(_scene_data)

func _finish_loading_scene(loaded_scene: PackedScene) -> void:
	_is_loading_resource = false
	await _replace_loaded_scene(loaded_scene)
	
	if _trans_type == SceneTransitionType.PROGRESS:
		await get_tree().create_timer(0.5).timeout
	
	_loading_screen.finish_loading_screen(_on_hide_screen_finished)

func _handle_loading_error(msg: String) -> void:
	push_error("Scene loading error: " + msg)
	_is_loading_resource = false
	_loading_screen.finish_loading_screen(_on_hide_screen_finished)

func _cleanup() -> void:
	_loading_screen = null
	_loading_scene_file = ""
	_scene_to_changed = null
	_trans_type = SceneTransitionType.PROGRESS
	_scene_data = null
	_is_loading_resource = false
	
	is_loading_scene = false
	loading_progress = 0.0
	loading_scene_finished.emit()
