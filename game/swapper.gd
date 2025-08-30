@tool
extends Node2D
class_name Swapper

@export var bit_seq: Array[Node2D]:
	set(nodes):
		bit_seq = nodes
		queue_redraw()

var animation_duration := 0.25 # in seconds

signal swap_done

var anim_queue: Array[String] = []

func _ready() -> void:
	var library: AnimationLibrary
	if not $AnimationPlayer.has_animation_library(""):
		library = AnimationLibrary.new()
		library.resource_local_to_scene = true
		$AnimationPlayer.add_animation_library("", library)
	else:
		library = $AnimationPlayer.get_animation_library("")
	if not anim_queue.is_empty():
		for anim_name in anim_queue:
			library.remove_animation(anim_name)
		anim_queue.clear()
	for i in range(len(bit_seq)):
		_build_swap_animation("swap_%d" % i, i)

func _build_swap_animation(anim_name: String, index: int) -> void:
	var anim = Animation.new()
	anim.length = animation_duration
	for i in range(len(bit_seq)):
		var bit_curr = bit_seq[i]
		var pos_curr = bit_seq[(i + index) % len(bit_seq)].global_position
		var pos_next = bit_seq[(i + 1 + index) % len(bit_seq)].global_position
		var track = anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(track, NodePath("%s:global_position" % bit_curr.get_path()))
		anim.track_insert_key(track, 0.0, pos_curr)
		anim.track_insert_key(track, animation_duration, pos_next)
		anim.track_set_key_transition(track, 0, Tween.EASE_IN_OUT)
		anim.track_set_key_transition(track, 1, Tween.EASE_IN_OUT)

	var library: AnimationLibrary = $AnimationPlayer.get_animation_library("")
	library.add_animation(anim_name, anim)
	anim_queue.push_back(anim_name)

func _draw():
	if not Engine.is_editor_hint():
		return
	if not bit_seq:
		return
	for i in range(len(bit_seq)):
		var bit_curr = bit_seq[i]
		var bit_next = bit_seq[(i + 1) % len(bit_seq)]
		if bit_curr and bit_next:
			draw_line(
				to_local(bit_curr.global_position),
				to_local(bit_next.global_position),
				Color.ORANGE,
				20.0,
				true # antialiased
			)

func do_swap() -> void:
	if not anim_queue.is_empty():
		$AnimationPlayer.play(anim_queue.front())
		await $AnimationPlayer.animation_finished
		anim_queue.push_back(anim_queue.pop_front())
	emit_signal("swap_done")
