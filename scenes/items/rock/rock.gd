extends Draggable2D

@export var shadow_opacity := 0.25
@export var use_speed := 0.25
@export var trans_type := Tween.TRANS_ELASTIC

@export_group("Node Values")
@export var shadow : Sprite2D
@export var mover : Node2D
@export var hitbox : CollisionShape2D

var queue_release := false

func _ready() -> void:
	super._ready()
	shadow.self_modulate = Color(0, 0, 0, shadow_opacity)
	ready_to_use = true
	hitbox.disabled = true
	shadow.visible = false

func use() -> void:
	if(!ready_to_use):
		return
	ready_to_use = false
	queue_release = false
	var target_pos := shadow.position
	var target_color := shadow.self_modulate
	target_color.a = 1
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(mover, "position", target_pos, use_speed).set_trans(trans_type)
	tween.tween_property(shadow, "self_modulate", target_color, use_speed).set_trans(trans_type)
	tween.finished.connect(tween_back)

func tween_back() -> void:
	hitbox.disabled = false
	await get_tree().create_timer(0.1).timeout
	hitbox.disabled = true
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(mover, "position", Vector2.ZERO, use_speed)
	tween.tween_property(shadow, "self_modulate", Color(0, 0, 0, shadow_opacity), use_speed)
	tween.finished.connect(finished_use)

func finished_use() -> void:
	if(queue_release):
		let_go()
	super.finished_use()

func _physics_process(delta) -> void:
	if(ready_to_use):
		super._physics_process(delta)
	elif(Input.is_action_just_released("mouse_click")):
		queue_release = true

func _on_picked_up() -> void:
	shadow.visible = true

func _on_released() -> void:
	shadow.visible = false
