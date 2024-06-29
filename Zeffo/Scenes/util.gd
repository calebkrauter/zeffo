extends Node2D
var paused = false
var bills = []
var billQuantity = 15
var frame = 10
var curBillIndex = 5
var totalCash = 0
var billMarginX = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	is_in_bill_array_bounds()

func is_in_bill_array_bounds():
	if curBillIndex <= 0:
		curBillIndex = 0
	elif curBillIndex >= billQuantity - 1:
		curBillIndex = billQuantity - 1
