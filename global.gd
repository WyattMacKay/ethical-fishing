extends Node

const distance_modifier := 1.0/8.0

signal fish_changed(Fish2D)

func set_fish(fish : Fish2D) -> void:
	fish_changed.emit(fish)
