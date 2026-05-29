class_name ObjectSlider
extends Node

@export var speed := 1.0
@export_group("Enter Info")
@export var enter_direction := Global.Direction.UP
@export var enter_trans := Tween.TRANS_ELASTIC
@export var enter_ease := Tween.EASE_IN_OUT

@export_group("Exit Info")
@export var exit_direction := Global.Direction.UP
@export var exit_trans := Tween.TRANS_ELASTIC
@export var exit_ease := Tween.EASE_IN_OUT

var children_position : Dictionary[Node, int]
var property : String
var signed : int

func initialize() -> void:
	property = get_property()
	signed = get_signed()

func get_property(enter : bool = true) -> String:
	var dir = enter_direction if enter else exit_direction
	var prop = "y" if dir == Global.Direction.DOWN or dir == Global.Direction.UP else "x"
	return "position:" + prop
func get_signed(enter : bool = true) -> int:
	var dir = enter_direction if enter else exit_direction
	return 1 if dir == Global.Direction.DOWN or dir == Global.Direction.RIGHT else -1

func _ready() -> void:
	initialize()
	for child in get_children(false):
		var child_pos = child.get_indexed(property)
		if child_pos != null:
			children_position[child] = child_pos
			child.set_indexed(property, child_pos + (1000 * signed))
		else:
			print("Failed")
	start_tweens()

func exit() -> void:
	await start_tweens(false)
	queue_free()

func start_tweens(enter : bool = true) -> void:
	var trans = enter_trans if enter else exit_trans 
	var _ease = enter_ease if enter else exit_ease
	for child in children_position:
		var tween : Tween = create_tween()
		tween.set_ease(_ease)
		tween.set_trans(trans)
		var position = children_position[child]
		if !enter:
			position += 1000 * signed
		tween.tween_property(child, get_property(enter), position, speed)
		var timer = get_tree().create_timer(speed/4)
		await timer.timeout
