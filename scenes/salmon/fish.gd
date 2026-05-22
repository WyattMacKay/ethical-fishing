extends Node2D

enum FishType {INVASIVE, MUST_RELEASE, KEEPABLE}
@export var type : FishType = FishType.INVASIVE

func _on_hittable_area_area_entered(_area: Area2D) -> void:
	print("Oh golly gee...")
