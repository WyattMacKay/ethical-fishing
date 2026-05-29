extends Node

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var hookline : Hookline

const distance_modifier := 1.0/8.0
var current_fish : Fish2D
var fish_transform : Transform2D

signal fish_changed(Fish2D)
signal measured(float)

func set_fish(fish : Fish2D) -> void:
	current_fish = fish
	if !fish_transform:
		fish_transform = fish.transform
	fish_changed.emit(fish)

func measure_finished(length : float) -> void:
	var diff = abs(length - current_fish.get_length())
	if(diff < 5.0):
		measured.emit(length)

func spawn_fish() -> void:
	var fish_slider := ObjectSlider.new()
	fish_slider.speed = 2.0
	fish_slider.enter_direction = Direction.DOWN
	fish_slider.exit_ease = Tween.EASE_OUT
	var fish_res := load("res://scenes/fish/salmon/salmon.tscn")
	var fish : Fish2D = fish_res.instantiate()
	fish.z_index = -1
	fish.transform = fish_transform
	fish_slider.add_child(fish)
	var sibling = get_parent().get_child(1)	# This is volatile as fuck Im an idiot bro
	if sibling == self:
		sibling = get_parent().get_child(0)
	sibling.add_child(fish_slider)

func fish_kept() -> void:
	exit_fish_slider(Global.Direction.RIGHT)

func fish_released() -> void:
	exit_fish_slider(Global.Direction.LEFT)

func exit_fish_slider(direction : Global.Direction) -> void:
	var par = current_fish.get_parent()
	if par:
		var parent : ObjectSlider = par
		parent.exit_direction = direction
		parent.exit()
		spawn_fish()
