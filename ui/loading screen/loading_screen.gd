extends CanvasLayer
class_name LoadingScreen

@onready var progress_transition: ProgressTransition = $ProgressTransition
@onready var fade_transition: FadeTransition = $FadeTransition

var _current_trans: Control

func start_loading_screen(trans_type: SceneManager.SceneTransitionType, on_show_cb: Callable):
	match trans_type:
		SceneManager.SceneTransitionType.PROGRESS:
			progress_transition.show_screen(on_show_cb)
			_current_trans = progress_transition
		SceneManager.SceneTransitionType.FADE:
			fade_transition.show_screen(on_show_cb)
			_current_trans = fade_transition

func finish_loading_screen(on_hide_cb: Callable):
	_current_trans.hide_screen(on_hide_cb)

func update_progress_transition(value: float):
	progress_transition.update_progress(value)
