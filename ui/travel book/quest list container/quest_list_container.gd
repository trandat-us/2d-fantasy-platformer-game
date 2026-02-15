extends Control

@onready var scroll_slider: VSlider = %ScrollSlider
@onready var scroll_container: ScrollContainer = $ScrollContainer

var max_scroll_px: int = 154

func _on_scroll_slider_value_changed(value: float) -> void:
	scroll_container.scroll_vertical = roundi(max_scroll_px * (1 - value))

func _on_scroll_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN or event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP:
			scroll_slider.value = 1 - float(scroll_container.scroll_vertical) / max_scroll_px
