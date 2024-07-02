extends Control

var selectedBillIndex
var selectBtnPressed = false
var flipBtnPressed = false
@onready var arrowRightBtn = $ArrowRight
@onready var selectBtn = $Select
@onready var arrowLeftBtn = $ArrowLeft
@onready var countBtn = $Count
@onready var flipBtn = $Flip
@onready var bundleBtn = $Bundle
@onready var controls = [arrowRightBtn, selectBtn, arrowLeftBtn, countBtn, flipBtn, bundleBtn]
var slideOffset = Util.bundledQuantity
#const SELECTOR_CAMERA = preload("res://Scenes/Entities/selectorCamera.tscn")
@onready var selector = $"../../Selector"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Util.bills.is_empty():
		controls_disabled(false)
		Util.is_in_bill_array_bounds()
		select_cur_bill()
		update_bill_scale()
		if selectBtnPressed:
			for n in Util.billQuantity:
				flip(Util.bills[n])
		if Util.curBillIndex >= Util.billQuantity-1:
			Util.newBoundL = Util.billQuantity - 11
		if Util.curBillIndex <= 0:
			Util.newBoundR = 10
		for n in Util.billQuantity:
			Util.bills[n].get_node("IndexLabel").text = str(Util.indeciesDisplayed[n])
	else:
		controls_disabled(true)

func controls_disabled(isDisabled):
	for n in controls.size():
		controls[n].disabled = isDisabled

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
	selector.get_node("SelectorSprite").position.x += Util.billMarginX * multiplicative
	

func slide_bills_left():
	if Util.curBillIndex >= Util.billQuantity-1:
		Util.newBoundR = Util.billQuantity-1
		
	if Util.curBillIndex > Util.newBoundR: #&& Util.curBillIndex > 9 && Util.curBillIndex != Util.billQuantity-1:
		for n in Util.billQuantity:
			Util.bills[n].position.x -= Util.billMarginX
			Util.newBoundL = Util.curBillIndex - 9
func slide_bills_right():
	if Util.curBillIndex <= 0:
		Util.newBoundL = 0
	if Util.curBillIndex < Util.newBoundL:# && Util.curBillIndex < Util.billQuantity - 10 && Util.curBillIndex != 0:
		for n in Util.billQuantity:
			Util.bills[n].position.x += Util.billMarginX
			Util.newBoundR = Util.curBillIndex + 9

func _on_count_pressed():
	pass

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

func flip_tails(curBill):
	curBill.get_node("Bill2D").frame = 0

func _on_bundle_pressed():
	if !Util.bills.is_empty():
		if Util.curBillIndex >= Util.bundledQuantity - 1:
			Util.bills[Util.curBillIndex].isSelected = false
			Util.curBillIndex = Util.curBillIndex - slideOffset
			Util.is_in_bill_array_bounds()
			Util.bills[Util.curBillIndex].isSelected = true
			# This only works for index selected at 30
			# TODO fix issue where sometimes bills slide to far and sometimes the wrong bill where the movable selector is.
			slideOffset = 11
		else:
			slideOffset = Util.bundledQuantity
		for n in Util.bundledQuantity:
			if n >= Util.bills.size():
				break
			Util.bills[0].hide()
			Util.bills.remove_at(0)
		if Util.bills.size() < Util.bundledQuantity:
			slideOffset = Util.bills.size()
		for n in Util.bills.size():
			Util.bills[n].position.x -= Util.billMarginX * slideOffset
			Util.newBoundL = Util.curBillIndex - 9

func select_cur_bill():
	Util.bills[Util.curBillIndex].get_node("BillSelect").show()

func unselect_cur_bill():
	Util.bills[Util.curBillIndex].get_node("BillSelect").hide()

func move_selected_bill(selectedBillIndex, targetIndex):
	var selectedBillDenomination = Util.bills[selectedBillIndex].get_denomination()
	var targetBillDenomination = Util.bills[targetIndex].get_denomination()
	
	Util.bills[targetIndex].set_denomination(selectedBillDenomination)
	Util.bills[selectedBillIndex].set_denomination(targetBillDenomination)
	if !Util.bills[selectedBillIndex].is_flipped() && !Util.bills[targetIndex].is_flipped():
		Util.bills[targetIndex].set_flipped(false)
		Util.bills[selectedBillIndex].set_flipped(false)
	elif Util.bills[selectedBillIndex].is_flipped() && !Util.bills[targetIndex].is_flipped():
		Util.bills[targetIndex].set_flipped(true)
		Util.bills[selectedBillIndex].set_flipped(false)
		flip(Util.bills[selectedBillIndex])
	elif !Util.bills[selectedBillIndex].is_flipped() && Util.bills[targetIndex].is_flipped():
		Util.bills[targetIndex].set_flipped(false)
		Util.bills[selectedBillIndex].set_flipped(true)
		flip(Util.bills[selectedBillIndex])
	elif Util.bills[selectedBillIndex].is_flipped() && Util.bills[targetIndex].is_flipped():
		Util.bills[targetIndex].set_flipped(true)
		Util.bills[selectedBillIndex].set_flipped(true)
