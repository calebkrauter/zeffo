extends Node2D

@onready var pause_menu_container = $PauseMenuContainer
@onready var pause_btn = $PauseBtn
@onready var money_manager_control = $"../../MoneyManagerControl"
@onready var bills_control = $"../../BillsFrame/BillsControl"

const STAGE_1 = preload("res://Scenes/Stages/Stage1.tscn")
#@onready var bills_parent = STAGE_1.$Bills


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu_container.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_game_state()


func _on_button_pressed():
	Util.paused = true
	

func change_game_state():
	if Util.paused:
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
		Util.bills[Util.curBillIndex].get_node("BillSelect").show()
		Engine.time_scale = 1
