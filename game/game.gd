extends Control
class_name Game

var bit_holder: BitHolder
static var level_id: int = 1

func _ready() -> void:
	load_level(level_id)

func _on_completed() -> void:
	$SuccessAudioPlayer.play()
	await get_tree().create_timer(1.5).timeout
	$SuccessAudioPlayer.stop()
	remove_child(bit_holder)
	bit_holder.level_completed.disconnect(_on_completed)
	load_level(level_id + 1)

func load_level(id: int) -> void:
	level_id = id
	var path := "res://game/levels/%d.tscn" % level_id
	if ResourceLoader.exists(path):
		bit_holder = (load(path) as PackedScene).instantiate()
		bit_holder.level_completed.connect(_on_completed)
		add_child(bit_holder)
	else:
		get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
