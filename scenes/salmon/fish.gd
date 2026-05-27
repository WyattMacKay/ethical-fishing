class_name Fish2D
extends Node2D

enum FishType {INVASIVE, MUST_RELEASE, KEEPABLE}
@export var type : FishType = FishType.INVASIVE
@export var sprite : Sprite2D
@export var minimum_size : float = 50.0

func _ready() -> void:
	Global.set_fish(self)

signal died()
signal hook_removed()

func _process(_delta: float) -> void:
	pass #print("%f" % get_size())

func get_size() -> float:
	var size : float = sprite.texture.get_width()
	size *= scale.x * sprite.scale.x
	return size * Global.distance_modifier

func get_tasks() -> Array[Task]:
	var tasks : Array[Task]
	# if type == FishType.INVASIVE:
	var kill_task = Task.new()
	kill_task.description = "Euthanize with rock."
	kill_task.related_signal = died
	tasks.push_back(kill_task)
	return tasks

func _on_hittable_area_area_entered(_area: Area2D) -> void:
	died.emit()
	hook_removed.emit() # DELETE THIS
