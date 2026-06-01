@abstract
class_name Draggable2D
extends Node2D

@export var tween_speed := 0.35
@export var pickup_rotation := 0.0

var click_started_here: bool = false
var start_pos: Vector2
var ready_to_use : bool
var pickup_tween : Tween

signal picked_up()
signal released()

func _ready() -> void:
	start_pos = position

func let_go() -> void:
	click_started_here = false
	if pickup_tween : pickup_tween.kill()
	pickup_tween = create_tween()
	pickup_tween.set_parallel()
	pickup_tween.set_ease(Tween.EASE_IN_OUT)
	pickup_tween.tween_property(self, "position", start_pos, tween_speed).set_trans(Tween.TRANS_QUAD)
	pickup_tween.tween_property(self, "rotation_degrees", 0, tween_speed).set_trans(Tween.TRANS_QUAD)
	released.emit()

func finished_use() -> void:
	ready_to_use = true
	if(!Input.is_action_pressed("mouse_click")):
		let_go()

func move_to_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	self.position.x = mouse_pos.x
	self.position.y = mouse_pos.y

func _physics_process(_delta) -> void:
	if(click_started_here):
		if(Input.is_action_pressed("mouse_click")):
			move_to_mouse()
		elif(Input.is_action_just_released("mouse_click")):
			let_go()

func _on_click_box_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if(event is InputEventMouseButton):
		if(Input.is_action_just_pressed("mouse_click")):
			click_started_here = true
			if pickup_tween : pickup_tween.kill()
			pickup_tween = create_tween()
			pickup_tween.tween_property(self, "rotation_degrees", pickup_rotation, tween_speed).set_trans(Tween.TRANS_QUAD)
			get_parent().move_child(self, get_parent().get_child_count() - 1)
			picked_up.emit()
		elif(Input.is_action_just_pressed("use_item") and click_started_here):
			use()

@abstract
func use() -> void
