extends Node2D

@export var active_fish : Fish2D
@export var label_container : Container
@export var header_label : Label
@export var label_settings : LabelSettings

var signals_labels : Dictionary[Signal, Label]

func _ready() -> void:
	active_fish = Global.current_fish
	Global.connect("fish_changed", _on_fish_changed)

func _on_fish_changed(fish : Fish2D) -> void:
	active_fish = fish
	header_label.text = fish.species
	for child : Node in label_container.get_children():
		child.queue_free()
	connect_signals()

func connect_signals() -> void:
	var tasks : Array[Task] = active_fish.get_tasks()
	for task : Task in tasks:
		var label = Label.new()
		label.text = "• " + task.description
		label.label_settings = label_settings
		label_container.add_child(label)
		signals_labels[task.related_signal] = label
		task.related_signal.connect(func(..._args : Array): task_complete(task.related_signal))

func task_complete(sig : Signal) -> void:
	signals_labels[sig].text = "Completed!"

func _on_keep_pressed() -> void:
	Global.fish_kept()

func _on_release_pressed() -> void:
	Global.fish_released()
