extends Control

var selectedBillIndex
var selectBtnPressed = false
var flipBtnPressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Util.is_in_bill_array_bounds()
	select_cur_bill()
	update_bill_scale()
	if selectBtnPressed:
		for n in Util.billQuantity:
			flip(Util.bills[n])
	if Util.curBillIndex >= Util.billQuantity-1:
		newBoundL = Util.billQuantity - 10
	if Util.curBillIndex <= 0:
		newBoundR = 10



func update_bill_scale():
	if Util.bills[Util.curBillIndex].isSelected && selectBtnPressed:
		Util.bills[Util.curBillIndex].get_node("Bill2D").scale = Vector2(0.38, 0.38)
	else:
		Util.bills[Util.curBillIndex].get_node("Bill2D").scale = Vector2(0.4, 0.4)


func _on_select_pressed():
	#selectBtnPressed = true
	if !selectBtnPressed:
		selectBtnPressed = true
		Util.bills[Util.curBillIndex].isSelected = true
	else:
		selectBtnPressed = false
		Util.bills[Util.curBillIndex].isSelected = false
	select_cur_bill()




func _on_arrow_left_pressed():
	arrow_pressed(-1)
	slide_bills_right()
func _on_arrow_right_pressed():
	arrow_pressed(1)
	slide_bills_left()

func arrow_pressed(multiplicative):
	unselect_cur_bill()
	selectedBillIndex = Util.curBillIndex
	Util.bills[selectedBillIndex].isSelected = false
	if selectBtnPressed:
		update_bill_scale()
	Util.curBillIndex += 1 * multiplicative
	Util.is_in_bill_array_bounds()
	Util.bills[Util.curBillIndex].isSelected = true
	if selectBtnPressed:
		var curBillIndex = Util.curBillIndex
		move_selected_bill(selectedBillIndex, curBillIndex)

var newBoundR = 10
var newBoundL = 0
func slide_bills_left():
	if Util.curBillIndex == Util.billQuantity - 1:
		return
	if !Util.curBillIndex >= Util.billQuantity - 1:
		if Util.curBillIndex > newBoundR: #&& Util.curBillIndex > 9 && Util.curBillIndex != Util.billQuantity-1:
			for n in Util.billQuantity:
				Util.bills[n].position.x -= Util.billMarginX
				newBoundL = Util.curBillIndex - 10
func slide_bills_right():

	if Util.curBillIndex > 0:
		if Util.curBillIndex < newBoundL:# && Util.curBillIndex < Util.billQuantity - 10 && Util.curBillIndex != 0:
			for n in Util.billQuantity:
				Util.bills[n].position.x += Util.billMarginX
				newBoundR = Util.curBillIndex + 10
func _on_count_pressed():
	pass # Replace with function body.


func _on_flip_pressed():
	flipBtnPressed = true
	
	var curBill = Util.bills[Util.curBillIndex]
	if curBill.get_node("Bill2D").get_frame() == 0:
		curBill.get_node("Bill2D").frame = 1
		curBill.set_flipped(true)
	else:
		curBill.get_node("Bill2D").frame = 0
		curBill.set_flipped(false)



func flip(curBill):
	
	if curBill.is_flipped():
		curBill.get_node("Bill2D").frame = 1
	else:
		curBill.get_node("Bill2D").frame = 0


func flip_heads(curBill):
	curBill.get_node("Bill2D").frame = 1
	#curBill.set_flipped(true)

func flip_tails(curBill):
	curBill.get_node("Bill2D").frame = 0
	#curBill.set_flipped(false)
	
func _on_bundle_pressed():
	pass # Replace with function body.

func select_cur_bill():
	Util.bills[Util.curBillIndex].get_node("BillSelect").show()

func unselect_cur_bill():
	Util.bills[Util.curBillIndex].get_node("BillSelect").hide()

func move_selected_bill(selectedBillIndex, targetIndex):
	var selectedBillDenomination = Util.bills[selectedBillIndex].get_denomination()
	var targetBillDenomination = Util.bills[targetIndex].get_denomination()
	

	#print(selectedBillIndex)
	#print(Util.curBillIndex)
	print("AHHHH")
	Util.bills[targetIndex].set_denomination(selectedBillDenomination)
	Util.bills[selectedBillIndex].set_denomination(targetBillDenomination)
	if !Util.bills[selectedBillIndex].is_flipped() && !Util.bills[targetIndex].is_flipped():
		Util.bills[targetIndex].set_flipped(false)
		Util.bills[selectedBillIndex].set_flipped(false)
		print(1)
	elif Util.bills[selectedBillIndex].is_flipped() && !Util.bills[targetIndex].is_flipped():
		Util.bills[targetIndex].set_flipped(true)
		Util.bills[selectedBillIndex].set_flipped(false)
		flip(Util.bills[selectedBillIndex])
		print(2)
	elif !Util.bills[selectedBillIndex].is_flipped() && Util.bills[targetIndex].is_flipped():
		Util.bills[targetIndex].set_flipped(false)
		Util.bills[selectedBillIndex].set_flipped(true)
		flip(Util.bills[selectedBillIndex])
		print(3)
	elif Util.bills[selectedBillIndex].is_flipped() && Util.bills[targetIndex].is_flipped():
		Util.bills[targetIndex].set_flipped(true)
		Util.bills[selectedBillIndex].set_flipped(true)
		print(4)

	
