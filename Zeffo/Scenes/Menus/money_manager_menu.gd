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
	if !selectBtnPressed:
		flipBtnPressed = false
	flip(Util.bills[Util.curBillIndex])
			


func update_bill_scale():
	if Util.bills[Util.curBillIndex].isSelected && selectBtnPressed:
		Util.bills[Util.curBillIndex].get_node("Bill2D").scale = Vector2(0.38, 0.38)
	else:
		Util.bills[Util.curBillIndex].get_node("Bill2D").scale = Vector2(0.4, 0.4)


func _on_select_pressed():
	if !selectBtnPressed:
		selectBtnPressed = true
		Util.bills[Util.curBillIndex].isSelected = true
	else:
		selectBtnPressed = false
		Util.bills[Util.curBillIndex].isSelected = false
	
	#if Util.bills[Util.curBillIndex].isSelected:
		#Util.bills[Util.curBillIndex].isSelected = false
	#else:
		#Util.bills[Util.curBillIndex].isSelected = true
	select_cur_bill()
	#print(Util.bills[Util.curBillIndex].denomination)



func _on_arrow_left_pressed():
	arrow_pressed(-1)
	#print(Util.bills[Util.curBillIndex].denomination)

func _on_arrow_right_pressed():
	arrow_pressed(1)
	#print(Util.bills[Util.curBillIndex].denomination)

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
		move_selected_bill(selectedBillIndex, Util.curBillIndex)
		#Util.bills[Util.curBillIndex].get_node("Bill2D").frame = 1

func _on_count_pressed():
	pass # Replace with function body.


func _on_flip_pressed():
	flipBtnPressed = true
	var curBill = Util.bills[Util.curBillIndex]
	if curBill.get_node("Bill2D").get_frame() == 0:
		#curBill.set_flipped(false)
		curBill.get_node("Bill2D").frame = 1
		curBill.heads = true
	else:
		#curBill.set_flipped(true)
		curBill.get_node("Bill2D").frame = 0
		curBill.heads = false
	


func flip(curBill):
	if selectBtnPressed && flipBtnPressed:
		if curBill.heads:
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
	var selectedBillIsFlipped = Util.bills[selectedBillIndex].is_flipped()
	var tempBillDenomination = Util.bills[targetIndex].get_denomination()
	var tempBillFlipped = Util.bills[targetIndex].is_flipped()
	if selectBtnPressed:
		Util.bills[targetIndex].set_denomination(selectedBillDenomination)
		Util.bills[targetIndex].set_flipped(selectedBillIsFlipped)
		Util.bills[selectedBillIndex].set_denomination(tempBillDenomination)
		Util.bills[selectedBillIndex].set_flipped(tempBillFlipped)
		if Util.bills[selectedBillIndex].heads:
			flip_tails(Util.bills[selectedBillIndex])
		#if Util.bills[selectedBillIndex].heads == false:
			#flip_tails(Util.bills[targetIndex])
		#if Util.bills[targetIndex].is_flipped() && !Util.bills[selectedBillIndex].is_flipped():
			#flip_tails(Util.bills[targetIndex])
			
		#else:
			#flip_heads(Util.bills[selectedBillIndex])
		#if flipBtnPressed && Util.bills[targetIndex].is_flipped():
			#flip(Util.bills[selectedBillIndex])
		#else:
			
		#if Util.bills[targetIndex].is_flipped():
			#flip_heads(Util.bills[targetIndex])
		#flip(Util.bills[selectedBillIndex])
	
