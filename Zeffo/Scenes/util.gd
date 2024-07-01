extends Node2D
var paused = false
var bills = []
var billQuantity = 60
var bundledQuantity = 30
var frameL = curBillIndex
var frameR = curBillIndex
var curBillIndex = 5
var totalCash = 0
var billMarginX = 100
var newBoundR = 10
var newBoundL = 0
var indeciesDisplayed = []

var bundles = []
#var center = get_viewport().get_visible_rect().size / 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	is_in_bill_array_bounds()
	if !bills.is_empty():
		billQuantity = bills.size()

func is_in_bill_array_bounds():
	if curBillIndex <= 0:
		curBillIndex = 0
	elif curBillIndex >= billQuantity - 1:
		curBillIndex = billQuantity - 1
