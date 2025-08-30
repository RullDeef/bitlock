extends Node

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")

func _on_select_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels_menu/levels_menu.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
