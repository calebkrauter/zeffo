extends Control

var selectedBillIndex
var selectBtnPressed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Util.is_in_bill_array_bounds()
	select_cur_bill()
	update_bill_scale()

func update_bill_scale():

	if Util.bills[Util.curBillIndex].isSelected && selectBtnPressed:
		Util.bills[Util.curBillIndex].get_node("Bill2D").scale = Vector2(0.38, 0.38)
	else:
		Util.bills[Util.curBillIndex].get_node("Bill2D").scale = Vector2(0.4, 0.4)


func _on_select_pressed():
	if !selectBtnPressed:
		selectBtnPressed = true
	else:
		selectBtnPressed = false
	
	if Util.bills[Util.curBillIndex].isSelected:
		Util.bills[Util.curBillIndex].isSelected = false
	else:
		Util.bills[Util.curBillIndex].isSelected = true
	select_cur_bill()
	print(Util.bills[Util.curBillIndex].denomination)



func _on_arrow_left_pressed():
	unselect_cur_bill()
	selectedBillIndex = Util.curBillIndex
	Util.bills[selectedBillIndex].isSelected = false
	if selectBtnPressed:
		update_bill_scale()
	Util.curBillIndex -= 1
	Util.is_in_bill_array_bounds()
	Util.bills[Util.curBillIndex].isSelected = true
	if selectBtnPressed:
		move_selected_bill(selectedBillIndex, Util.curBillIndex)
	print(Util.bills[Util.curBillIndex].denomination)

func _on_arrow_right_pressed():
	unselect_cur_bill()
	selectedBillIndex = Util.curBillIndex
	Util.bills[selectedBillIndex].isSelected = false
	if selectBtnPressed:
		update_bill_scale()
	Util.curBillIndex += 1
	Util.is_in_bill_array_bounds()
	Util.bills[Util.curBillIndex].isSelected = true
	if selectBtnPressed:
		move_selected_bill(selectedBillIndex, Util.curBillIndex)
	print(Util.bills[Util.curBillIndex].denomination)

func _on_count_pressed():
	pass # Replace with function body.


func _on_flip_pressed():
	pass # Replace with function body.


func _on_bundle_pressed():
	pass # Replace with function body.

func select_cur_bill():
	Util.bills[Util.curBillIndex].get_node("BillSelect").show()

func unselect_cur_bill():
	Util.bills[Util.curBillIndex].get_node("BillSelect").hide()

# TODO: fix bug where moving a bill doesn't actually move it.
# The denomination is printing in console and should indicate wheter it 
# swaps bills or not. Currently it does not. Might be that the copy isn't deep.
# Duplicate didn't seem to help.
func move_selected_bill(selectedBillIndex, targetIndex):
	var tempBill = Util.bills[targetIndex]
	var selectedBillDenomination = Util.bills[selectedBillIndex].denomination
	var tempBillDenomination = Util.bills[targetIndex].denomination
	print(tempBillDenomination)
	if Util.bills[selectedBillIndex].isSelected:
		Util.bills[targetIndex] = (Util.bills[selectedBillIndex]) 

		Util.bills[targetIndex].set_val(selectedBillDenomination)
		Util.bills[selectedBillIndex].denomination = tempBillDenomination
		Util.bills[selectedBillIndex] = tempBill
	Util.bills[selectedBillIndex].set_val(tempBillDenomination)
	print(Util.bills[selectedBillIndex].denomination)

