extends Control

var bit_holder: BitHolder
var level_id: int = 1

func _ready() -> void:
	load_level(level_id)

func _on_completed() -> void:
	remove_child(bit_holder)
	load_level(level_id + 1)

func load_level(level_id: int) -> void:
	self.level_id = level_id
	bit_holder = (load("res://game/levels/%d.tscn" % level_id) as PackedScene).instantiate()
	bit_holder.level_completed.connect(_on_completed)
	add_child(bit_holder)
