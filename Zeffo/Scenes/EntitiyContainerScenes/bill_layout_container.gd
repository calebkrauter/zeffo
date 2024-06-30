class_name BillGenerator
extends Node2D
var bill = preload("res://Scenes/Entities/bill.tscn")
@onready var bills = $"."
@onready var billLayoutContainer = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	gen_bills(Util.billQuantity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Util.frameL = Util.curBillIndex -10
	Util.frameR = Util.curBillIndex +10
	if Util.frameL <=0:
		Util.frameL = 0
	if Util.frameR >= Util.billQuantity -1:
		Util.frameR = Util.billQuantity -1
	for n in Util.billQuantity:
		if billLayoutContainer.is_ancestor_of(Util.bills[n]):
			is_out_of_frame(n)
		#else:
			
		

func is_out_of_frame(n):
	if n < Util.frameL:
		Util.bills[n].hide()
	if n > Util.frameR:
		Util.bills[n].hide()
	if n <= Util.frameR && n > Util.frameL:
		Util.bills[n].show()
	if n >= Util.frameL && n < Util.frameR:
		Util.bills[n].show()

func gen_bills(quantity):
	var newBill
	var originPosX = 25
	var originPosY = 250

	for n in quantity:
		newBill = bill.instantiate()
		bills.add_child(newBill)
		newBill.position.x += originPosX + n * Util.billMarginX
		newBill.position.y = originPosY
		Util.bills.append(newBill)
		Util.indeciesDisplayed.append(n+1)
		
		
#Temp assign diff values to some bills to ensure selection works proprerly.
		if n % 2 == 0:
			Util.bills[n].get_node("Bill2D").play("1")
			Util.bills[n].set_flipped(false)
			Util.bills[n].set_denomination("1")
		else:
			Util.bills[n].get_node("Bill2D").play("5")
			Util.bills[n].set_flipped(false)
			Util.bills[n].set_denomination("5")
