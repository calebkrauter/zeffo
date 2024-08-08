extends Node2D
var paused = false
var bills = []
var billQuantity = 70
var bundledQuantity = 30
var frameL = curBillIndex
var frameR = curBillIndex
var curBillIndex = 5
var actualTotal = 0
var amountToKeep = 10
# When the difficulty curve is implemented, this should be updated.
# amountToKeep should be based on the amount of cash to deposit
# which should change each day.
var expectedCashToDeposit = 0
var countedTotal = 0
var billsCounted = 0
var billMarginX = 100
var newBoundR = 10
var newBoundL = 0
var indeciesDisplayed = []
var billPosXOffset = 77.5
var billPosYOffset = 250
var startingIndexBillPosXOffset = 500
var bundles = []
var grandTotal = 0
var keptCash = 0
var score = 0
var scoreFromCount = 0
var scoreFromSort = 0
var scoreFromBundle = 0
var scoreFromHeads = 0
# Adjust these weights as necessary to balance the game.
var weightCountScore = 3
var weightSortScore = 2
var weightBundleScore = 1
var weightHeadsScore = 2
# The score barrier may need to be dynamic and based on the current day's
# number of bills and days.
var minimumScoreToSurvive = 600
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
