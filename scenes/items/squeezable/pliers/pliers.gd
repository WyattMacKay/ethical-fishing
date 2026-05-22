extends Squeezable2D

@export var pinpoint : CollisionObject2D
@export var interactor_hitbox : CollisionShape2D

var connected_node : PhysicsBody2D
var joint: PinJoint2D

func _ready() -> void:
	super._ready()
	interactor_hitbox.disabled = true

func create_joint(body1: CollisionObject2D, body2: CollisionObject2D) -> PinJoint2D:
	var pj := PinJoint2D.new()
	pj.softness = 0.5
	pj.angular_limit_enabled = true
	pj.angular_limit_lower = -10.0
	pj.angular_limit_upper = 10.0
	pj.node_a = body1.get_path()
	pj.node_b = body2.get_path()
	return pj

func fully_squeezed() -> void:
	interactor_hitbox.disabled = false
	var timer = get_tree().create_timer(0.1)
	timer.timeout.connect(disable_hitbox)

func disable_hitbox() -> void:
	interactor_hitbox.disabled = true

func unsqueezed() -> void:
	if(joint) : joint.queue_free()

func _on_interactor_body_entered(body: Node2D) -> void:
	if(joint) : joint.queue_free()
	joint = create_joint(pinpoint, body)
	add_child(joint)
