extends Node

const distance_modifier := 1.0/8.0
var current_fish : Fish2D

signal fish_changed(Fish2D)
signal measured(float)

func set_fish(fish : Fish2D) -> void:
	current_fish = fish
	fish_changed.emit(fish)

func measure_finished(length : float) -> void:
	var diff = abs(length - current_fish.get_length())
	if(diff < 5.0):
		measured.emit(length)
