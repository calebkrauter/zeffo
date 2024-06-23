class_name BillGenerator
extends Node2D
var bill = preload("res://Scenes/Entities/bill.tscn")
@onready var bills = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	gen_bills(Util.billQuantity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func gen_bills(quantity):
	var newBill
	var originPosX = 200
	var originPosY = 250

	for i in quantity:
		newBill = bill.instantiate()
		bills.add_child(newBill)
		newBill.position.x += originPosX + i * 100
		newBill.position.y = originPosY
		Util.bills.append(newBill)
	Util.bills[Util.curBillIndex].get_node("BillSelect").show()
