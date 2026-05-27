class_name Fish2D
extends Node2D

enum FishType {INVASIVE, MUST_RELEASE, KEEPABLE}
@export var type : FishType = FishType.INVASIVE
@export var sprite : Sprite2D
@export var minimum_size : float = 50.0
@export var maximum_size : float = NAN

func _ready() -> void:
	Global.set_fish(self)

signal died()
signal hook_removed()

func get_length() -> float:
	var size : float = sprite.texture.get_width()
	size *= scale.x * sprite.scale.x
	return size * Global.distance_modifier

func create_task(description : String, sig : Signal) -> Task:
	var task = Task.new()
	task.description = description
	task.related_signal = sig
	return task

func get_tasks() -> Array[Task]:
	var tasks : Array[Task]
	# if type == FishType.INVASIVE:
	tasks.push_back(create_task("Euthanize with rock.", died))
	tasks.push_back(create_task("Measure (Tip to tail)", Global.measured))
	
	return tasks

func _on_hittable_area_area_entered(_area: Area2D) -> void:
	died.emit()
	hook_removed.emit() # DELETE THIS
