extends Node2D
const BILL_LAYOUT_CONTAINER = preload("res://Scenes/EntitiyContainerScenes/bill_layout_container.tscn")

# Called when the node enters the scene tree for the first time.
#@onready var cashTotal = $CashTotal
@onready var bills = $BillsFrame/BillsControl
@export var newBillLayout : BillGenerator
@onready var cashTotal = $Selector/CameraContainer/CashTotal
@onready var growingTotal = $Selector/CameraContainer/GrowingTotal
@onready var billsCounted = $Selector/CameraContainer/BillsCounted
@onready var unverifiedCount = $Selector/CameraContainer/UnverifiedCount
@onready var keptCash = $Selector/CameraContainer/KeptCash

# Called when the node enters the scene tree for the first time.
func _ready():
	newBillLayout = BILL_LAYOUT_CONTAINER.instantiate()
	bills.add_child(newBillLayout)
	for i in Util.billQuantity:
		Util.actualTotal += int(Util.bills[i].get_denomination())
	Util.expectedCashToDeposit = Util.actualTotal - Util.amountToKeep
	cashTotal.text = "You should have: $" + str(Util.expectedCashToDeposit)
	growingTotal.text = "Current Total: $" + str(Util.countedTotal)
	billsCounted.text = "Bills Counted: #" + str(Util.billsCounted)
	unverifiedCount.text = "Unverified Count: $" + str(Util.grandTotal)
	keptCash.text = "You KEPT: $" + str(Util.keptCash)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	growingTotal.text = "Current Total: $" + str(Util.countedTotal)
	billsCounted.text = "Bills Counted: #" + str(Util.billsCounted)
	unverifiedCount.text = "Unverified Count: $" + str(Util.grandTotal)
	keptCash.text = "You KEPT: $" + str(Util.keptCash)
