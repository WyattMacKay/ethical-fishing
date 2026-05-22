extends Node2D

@export var line : Line2D
var line_origin : Vector2

func _ready() -> void:
	line_origin = line.to_global(line.get_point_position(0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	line.set_point_position(0, line.to_local(line_origin))
	
