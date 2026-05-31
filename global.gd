extends Node

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var hookline : Hookline
var fish_res := [preload("res://scenes/fish/salmon/salmon.tscn"), 
				preload("res://scenes/fish/chain-pickerel/chain_pickerel.tscn")]

var distance_modifier := 1.0/8.0
var current_fish : Fish2D
var fish_position : Vector2
var default_zoom : float
var background : CanvasLayer

signal fish_changed(Fish2D)
signal measured(float)

func set_fish(fish : Fish2D) -> void:
	current_fish = fish
	if !fish_position:
		fish_position = fish.position
		default_zoom = current_fish.average_species_size
	distance_modifier = fish.size_modifier
	fish_changed.emit(fish)

func set_background(canvas : CanvasLayer) -> void:
	background = canvas

func measure_finished(length : float) -> void:
	var diff = abs(length - current_fish.get_length())
	if(diff < (current_fish.get_length() * 0.05)):
		measured.emit(length)

func spawn_fish() -> void:
	var fish_slider := ObjectSlider.new()
	fish_slider.speed = 2.0
	fish_slider.enter_direction = Direction.DOWN
	fish_slider.exit_ease = Tween.EASE_OUT
	var fish_res_index = randi() % fish_res.size() - 1
	var fish : Fish2D = fish_res[fish_res_index].instantiate()
	fish.z_index = -1
	fish.position = fish_position
	fish_slider.add_child(fish)
	var sibling = get_parent().get_child(1)	# This is volatile as fuck Im an idiot bro
	if sibling == self:
		sibling = get_parent().get_child(0)
	sibling.add_child(fish_slider)
	call_deferred("set_zoom", fish)

func set_zoom(fish : Fish2D) -> void:
	var scale_mod := default_zoom / fish.average_species_size
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(background, "scale", Vector2(scale_mod, scale_mod), 1.0)

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
