extends Node
class_name Bit

@onready var mat := $Sprite.material as ShaderMaterial

var max_value := 5:
	set(value):
		max_value = value
		_update_shader()

@export var clickable := true:
	set(value):
		clickable = value
		_update_shader()

@export var value: int = 0:
	set(new_value):
		value = new_value
		$Sprite/Label.text = "%d" % value if value > 0 else ""
		_update_shader()

signal before_clicked(Bit)
signal after_clicked(Bit)

func decay() -> void:
	if clickable:
		value = max(0, value - 1)

func activate() -> void:
	value = max_value
	$ClickAudioPlayer.play(0.2)

func _update_shader() -> void:
	if mat != null:
		var base_color := Color(0.4, 1.0, 0.4) if clickable else Color(1.0, 0.4, 0.4)
		mat.set_shader_parameter(&"base_color", base_color)
		mat.set_shader_parameter(&"clickable", 1.0 if clickable else 0.0)
		mat.set_shader_parameter(&"value", float(value) / max_value)
		$Sprite.queue_redraw()

func _ready() -> void:
	value = value
	clickable = clickable

func _on_sprite_gui_input(event: InputEvent) -> void:
	if clickable and event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal(&"before_clicked", self)
			activate()
			emit_signal(&"after_clicked", self)
