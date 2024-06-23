class_name Bill
extends Node2D
@onready var bill_Select = $BillSelect
var isSelected = false
#var isFlipped = false
var denomination


# Called when the node enters the scene tree for the first time.
func _ready():
	bill_Select.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
