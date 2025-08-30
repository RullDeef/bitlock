@tool
extends Node2D
class_name Swapper

@export var bit_1: Node2D:
	set(node):
		bit_1 = node
		queue_redraw()

@export var bit_2: Node2D:
	set(node):
		bit_2 = node
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
		library.remove_animation("swap_12")
		library.remove_animation("swap_21")
		anim_queue.clear()
	_build_swap_animation("swap_12", bit_1.global_position, bit_2.global_position, false)
	_build_swap_animation("swap_21", bit_2.global_position, bit_1.global_position, true)

func _build_swap_animation(anim_name: String, pos_1: Vector2, pos_2: Vector2, over: bool) -> void:
	var anim = Animation.new()
	anim.length = animation_duration

	var trackA = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(trackA, NodePath("%s:global_position" % bit_1.get_path()))
	anim.track_insert_key(trackA, 0.0, pos_1)
	anim.track_insert_key(trackA, animation_duration, pos_2)
	
	var trackA_size = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(trackA_size, NodePath("%s:scale" % (bit_1 if over else bit_2).get_path()))
	anim.track_insert_key(trackA_size, 0.0, Vector2(1, 1))
	anim.track_insert_key(trackA_size, animation_duration / 2, Vector2(0.5, 0.5))
	anim.track_insert_key(trackA_size, animation_duration, Vector2(1, 1))

	var trackB = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(trackB, NodePath("%s:global_position" % bit_2.get_path()))
	anim.track_insert_key(trackB, 0.0, pos_2)
	anim.track_insert_key(trackB, animation_duration, pos_1)

	for t in [trackA, trackA_size, trackB]:
		for k in 2:
			anim.track_set_key_transition(t, k, Tween.EASE_IN_OUT)
	var library: AnimationLibrary = $AnimationPlayer.get_animation_library("")
	library.add_animation(anim_name, anim)
	anim_queue.push_back(anim_name)

func _draw():
	if not Engine.is_editor_hint():
		return
	if not bit_1 or not bit_2:
		return
	draw_line(
		to_local(bit_1.global_position),
		to_local(bit_2.global_position),
		Color.ORANGE,
		20.0,
		true # antialiased
	)

func do_swap() -> void:
	$AnimationPlayer.play(anim_queue.front())
	await $AnimationPlayer.animation_finished
	anim_queue.push_back(anim_queue.pop_front())
	emit_signal("swap_done")
