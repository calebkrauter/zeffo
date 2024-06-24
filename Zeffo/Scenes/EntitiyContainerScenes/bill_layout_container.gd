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
	var originPosX = 100
	var originPosY = 250

	for i in quantity:
		newBill = bill.instantiate()
		bills.add_child(newBill)
		newBill.position.x += originPosX + i * 100
		newBill.position.y = originPosY
		Util.bills.append(newBill)
		
#Temp assign diff values to some bills to ensure selection works proprerly.
		if i % 2 == 0:
			#Util.bills[i].denomination = 1
			Util.bills[i].get_node("Bill2D").play("1")
			Util.bills[i].set_flipped(false)
			Util.bills[i].set_denomination("1")
		else:
			#Util.bills[i].denomination = 5
			Util.bills[i].get_node("Bill2D").play("5")
			Util.bills[i].set_denomination("5")
