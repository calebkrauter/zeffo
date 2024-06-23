extends Control
@onready var back = $MarginContainer/VBoxContainer/Play
@onready var options = $MarginContainer/VBoxContainer/Options
@onready var credits = $MarginContainer/VBoxContainer/Credits
@onready var quit = $MarginContainer/VBoxContainer/Quit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Stages/Stage1.tscn")

func _on_quit_pressed():
	get_tree().quit()

