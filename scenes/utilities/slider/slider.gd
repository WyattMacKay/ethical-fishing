extends Node

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}
@export var direction : Direction = Direction.UP
@export_group("Tween Info")
@export var speed := 1.0
@export var tween_trans := Tween.TRANS_ELASTIC
@export var tween_ease := Tween.EASE_IN_OUT

var children_position : Dictionary[Node, int]
var property : String
var signed : int

func initialize() -> void:
	property = "y" if direction == Direction.DOWN or direction == Direction.UP else "x"
	signed = 1 if direction == Direction.DOWN or direction == Direction.RIGHT else -1

func _ready() -> void:
	initialize()
	for child in get_children(false):
		var child_pos = child.get_indexed("position:" + property)
		if child_pos != null:
			children_position[child] = child_pos
			child.set_indexed("position:" + property, child_pos + (1000 * signed))
		else:
			print("Failed")
	start_tweens()

func start_tweens() -> void:
	
	for child in children_position:
		var tween : Tween = create_tween()
		tween.set_ease(tween_ease)
		tween.set_trans(tween_trans)
		tween.tween_property(child, "position:" + property, children_position[child], speed)
		var timer = get_tree().create_timer(speed/4)
		await timer.timeout
		
