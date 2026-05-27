extends Node2D

@export var line : Line2D
@export var include_line_end := false
var line_origin : Vector2
var line_end : Vector2

func _ready() -> void:
	line_origin = line.to_global(line.get_point_position(0))
	line_end = line.to_global(line.get_point_position(line.get_point_count()-1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	line.set_point_position(0, line.to_local(line_origin))
	if include_line_end:
		line.set_point_position(-1, line.to_local(line_end))
