@abstract
class_name Draggable2D
extends Node2D

var click_started_here: bool = false
var start_pos: Vector2

signal picked_up()
signal released()

func _ready() -> void:
	start_pos = position

func let_go() -> void:
	click_started_here = false
	position = start_pos
	released.emit()

func move_to_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	self.position.x = mouse_pos.x
	self.position.y = mouse_pos.y

func _physics_process(_delta) -> void:
	if(click_started_here):
		if(Input.is_action_just_released("mouse_click")):
			let_go()
		
		elif(Input.is_action_pressed("mouse_click")):
			move_to_mouse()

func _on_click_box_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if(event is InputEventMouseButton):
		if(Input.is_action_just_pressed("mouse_click")):
			click_started_here = true
			picked_up.emit()
		elif(Input.is_action_just_pressed("use_item") and click_started_here):
			use()

@abstract
func use() -> void
