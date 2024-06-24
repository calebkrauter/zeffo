class_name Bill
extends Node2D
@onready var bill_Select = $BillSelect
var isSelected = false
var isFlipped = false
var isBundled = false
var denomination = "1"


func set_denomination(denomination_in):
	self.denomination = denomination_in

func get_denomination():
	return self.denomination

func set_flipped(flipped_in):
	self.isFlipped = flipped_in

func is_flipped():
	return self.isFlipped
# Called when the node enters the scene tree for the first time.
func _ready():
	bill_Select.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play_animation(self.denomination)

func play_animation(denomination_in):
	self.get_node("Bill2D").play(denomination_in) 
