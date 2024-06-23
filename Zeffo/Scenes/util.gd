extends Node2D
var paused = false
var bills = []
var billQuantity = 10
var curBillIndex = billQuantity/2 + 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if curBillIndex <= 0:
		curBillIndex = 0
	elif curBillIndex >= billQuantity - 1:
		curBillIndex = billQuantity - 1
	
