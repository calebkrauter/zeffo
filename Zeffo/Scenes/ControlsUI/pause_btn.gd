extends Node2D
@onready var pause_menu_container = $PauseMenuContainer
@onready var pause_btn = $PauseBtn
var paused = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu_container.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	paused = true
	if paused:
		pause_btn.hide()
		pause_menu_container.show()
		Engine.time_scale = 0
	else:
		pause_btn.show()
		pause_menu_container.hide()
		Engine.time_scale = 1
	paused = false
