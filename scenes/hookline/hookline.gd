#extends Node2D
extends Draggable2D

@export var line : Line2D

var line_origin_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_origin_pos = to_global(line.get_point_position(0))
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	line.set_point_position(0, to_local(line_origin_pos))

func use(): pass
