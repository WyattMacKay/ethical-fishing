class_name Squeezable2D
extends Draggable2D

@export var use_speed := 0.2
@export_group("Handles")
@export var left : Sprite2D
@export var right : Sprite2D
@export var rest_rot := 15.0

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

func use(): 
	if tween : tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(left, "rotation_degrees", 0, use_speed).set_trans(Tween.TRANS_SINE)
	tween.tween_property(right, "rotation_degrees", 0, use_speed).set_trans(Tween.TRANS_SINE)

func unuse():
	if tween : tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(left, "rotation_degrees", rest_rot, use_speed).set_trans(Tween.TRANS_SINE)
	tween.tween_property(right, "rotation_degrees", -rest_rot, use_speed).set_trans(Tween.TRANS_SINE)

func _on_released() -> void:
	if tween : tween.kill()
	left.rotation_degrees = rest_rot
	right.rotation_degrees = -rest_rot

func _on_clickable_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if(Input.is_action_just_released("use_item")): unuse()
