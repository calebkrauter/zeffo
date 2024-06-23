extends Node2D

@onready var pause_menu_container = $PauseMenuContainer
@onready var pause_btn = $PauseBtn
@onready var money_manager_control = $"../../MoneyManagerControl"
@onready var bills_control = $"../../BillsControl"

const STAGE_1 = preload("res://Scenes/Stages/Stage1.tscn")
#@onready var bills_parent = STAGE_1.$Bills
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
		money_manager_control.hide()
		bills_control.hide()
		Engine.time_scale = 0
	else:
		pause_btn.show()
		pause_menu_container.hide()
		money_manager_control.show()
		bills_control.show()	
		Engine.time_scale = 1
	paused = false
