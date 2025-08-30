extends Panel

func _ready() -> void:
	var level_id := 1
	var path := "res://game/levels/%d.tscn" % level_id
	while ResourceLoader.exists(path):
		var btn := Button.new()
		btn.text = "%d" % level_id
		$LevelButtons.add_child(btn)
		btn.custom_minimum_size = Vector2(64, 64)
		btn.button_up.connect(func(): load_level(level_id))
		level_id += 1
		path = "res://game/levels/%d.tscn" % level_id

func load_level(id: int) -> void:
	Game.level_id = id
	get_tree().change_scene_to_packed(preload("res://game/game.tscn"))

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
