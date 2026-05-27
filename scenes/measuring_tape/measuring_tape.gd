extends Draggable2D

@export var notch : Sprite2D
@export var distance_label : Label
@export_group("Tape Nodes")
@export var line : Line2D
@export var line_begin : Node2D
@export var line_end : Node2D

@onready var notch_start_transform = notch.transform

# Maybe make it need held?

func _process(_delta) -> void:
	update_line()
	
func update_line() -> void:
	line.set_point_position(0, to_local(line_begin.global_position))
	line.set_point_position(0, to_local(line_end.global_position))
	var diff = line_begin.global_position - line_end.global_position
	var distance := diff.length() * Global.distance_modifier 
	distance_label.text = "%04.1f" % distance

func use() -> void:
	var notch_glob = notch.global_position
	notch.top_level = true
	notch.global_position = notch_glob
	notch.scale = notch_start_transform.get_scale() * scale

func _on_released() -> void:
	var notch_pos = to_local(notch.global_position)
	notch.top_level = false
	notch.position = notch_pos
	notch.scale = notch_start_transform.get_scale()
	var tween := create_tween()
	tween.tween_property(notch, "transform", notch_start_transform, tween_speed).set_trans(Tween.TRANS_SINE)
	update_line()
	#play tape measure sound
