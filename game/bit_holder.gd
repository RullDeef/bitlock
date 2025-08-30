extends Node2D
class_name BitHolder

@export var max_value := 5

signal level_completed

func decay_all_bits() -> void:
	_decay_all_bits_except(null)

func _ready() -> void:
	# connect all bits to function that decays all of them before activating clicked one
	for child in get_children():
		if child is Bit:
			var bit := child as Bit
			bit.max_value = max_value
			bit.before_clicked.connect(_decay_all_bits_except)
			bit.after_clicked.connect(_after_clicked)
	decay_all_bits()

func _decay_all_bits_except(except: Bit) -> void:
	for child in get_children():
		if child is Bit:
			var bit := child as Bit
			if bit != except:
				bit.decay()

func _after_clicked(_bit: Bit) -> void:
	# apply swappers
	var animation_signals = []
	for child in get_children():
		if child is Swapper:
			var swapper := child as Swapper
			swapper.do_swap()
			animation_signals.push_back(swapper.swap_done)
	for sig in animation_signals:
		await sig
	if check_solution():
		# make all unclickable bits clickable and emit completed signal after some time
		for child in get_children():
			if child is Bit:
				var bit := child as Bit
				if not bit.clickable:
					bit.clickable = true
		# await get_tree().create_timer(1).timeout
		emit_signal(&"level_completed")

func check_solution() -> bool:
	var satisfied := true
	var bits_green: Array[Bit] = []
	var bits_red: Array[Bit] = []
	var mirrors: Array[Line2D] = []
	for child in get_children():
		if child is Bit:
			var bit := child as Bit
			(bits_green if bit.clickable else bits_red).append(bit)
		if child is Line2D:
			mirrors.push_back(child as Line2D)
	for mirror in mirrors:
		var p1 := mirror.get_point_position(0)
		var p2 := mirror.get_point_position(1)
		var mirror_dir := p1.direction_to(p2)
		# check that each green bit has corresponding red bit
		for green_bit in bits_green:
			var p: Vector2 = green_bit.position
			var mirrored_pos = (p - p1).reflect(mirror_dir) + p1
			# find corresponding red bit
			for red_bit in bits_red:
				if red_bit.position == mirrored_pos:
					if green_bit.value != red_bit.value:
						satisfied = false
					break
	return satisfied
