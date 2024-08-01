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
#@onready var selector = $"../../Selector"
@onready var selector = $"../../.."
var selfTargetBill
var selfSelectedBill
var bundlePressed = false
@onready var movable = $Movable
@onready var bundle2d = $Bundle2D
const BUNDLE = preload("res://Scenes/Entities/bundle.tscn")
#var billLayoutContainer = Stage1OG.newBillLayout
@onready var moneyManagerMenu = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	prevSelectorPos = selector.position.x
	selfDelta = 0
	prevBillPos = selector.position.x
	await get_tree().process_frame
	selfTargetBill = Util.bills[Util.curBillIndex]
	selfSelectedBill = Util.bills[Util.curBillIndex]
	verify_counted.visible = false
var hitBound = false
var hitBoundL = false
var hitBoundR = false
var direction = 1
var prevSelectorPos = 0
var prevBillPos = 0
var stop = false
var selfDelta
var curBillRelativePosition = 0
var billIterater = 0
@onready var verify_counted = $"../../VerifyCounted"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	selfDelta = delta
	if Util.curBillIndex > Util.bills.size() - 1:
		Util.curBillIndex = Util.bills.size() - 1
	if !Util.bills.is_empty():
		curBillRelativePosition = Util.bills[Util.curBillIndex].position.x - Util.billPosXOffset - Util.startingIndexBillPosXOffset
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
	if hitBoundL || leftPressed :
		arrowLeftBtn.disabled = true
	else:
		arrowLeftBtn.disabled = false
	if hitBoundR || rightPressed:
		arrowRightBtn.disabled = true
	else:
		arrowRightBtn.disabled = false
	slide_selector(delta)
	move_bills(delta)

func move_bills(delta):
	if bundlePressed && selector.position.x >= curBillRelativePosition:
		var varianceOffset = abs(selector.position.x - curBillRelativePosition)
		for n in Util.bills.size():
			Util.bills[n].position.x += varianceOffset
			Util.bills[n].get_node("Bill2D").scale = Vector2(0.4, 0.4)
		bundlePressed = false
	if bundlePressed && curBillRelativePosition != selector.position.x:
		for n in Util.bills.size():
			Util.bills[n].position.x -= 5000 * delta
			Util.bills[n].get_node("Bill2D").scale = Vector2(0.38, 0.38)




func slide_selector(delta):
	if direction == 1 && rightPressed:
		#print("1")
		#print(selector.position.x)
		if selector.position.x < prevSelectorPos + Util.billMarginX * direction:
			#print("2")
			selector.position.x += direction * delta * 2500
			if selector.position.x >= prevSelectorPos + Util.billMarginX * direction:
				#print("3")
				selector.position.x = prevSelectorPos + Util.billMarginX * direction
		else:
			#print("4")
			prevSelectorPos = selector.position.x
			rightPressed = false
	elif direction == -1 && leftPressed:
		#print("1")
		if selector.position.x > prevSelectorPos + Util.billMarginX * direction:
			#print("2")
			selector.position.x += direction * delta * 2500
			if selector.position.x <= prevSelectorPos + Util.billMarginX * direction:
				#print("3")
				selector.position.x = prevSelectorPos + Util.billMarginX * direction
		else:
			#print("4")
			prevSelectorPos = selector.position.x
			leftPressed = false

func controls_disabled(isDisabled):
	for n in controls.size():
		controls[n].disabled = isDisabled

func update_bill_scale():
	if Util.bills[Util.curBillIndex].isSelected && selectBtnPressed:
		selector.get_node("CameraContainer/Selector2D").scale = Vector2(0.38, 0.38)
		Util.bills[Util.curBillIndex].get_node("Bill2D").scale = Vector2(0.38, 0.38)
	else:
		selector.get_node("CameraContainer/Selector2D").scale = Vector2(0.4, 0.4)
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
var leftPressed = false
var rightPressed = false
func _on_arrow_left_pressed():
	arrow_pressed(-1)
	direction = -1
	if leftPressed:
		leftPressed = false
	else:
		leftPressed = true

func _on_arrow_right_pressed():
	arrow_pressed(1)
	direction = 1
	if rightPressed:
		rightPressed = false
	else:
		rightPressed = true

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
	
	if Util.curBillIndex > 0 && Util.curBillIndex < Util.bills.size() - 1:
		hitBound = false
		hitBoundL = false
		hitBoundR = false
	if Util.curBillIndex >= 0 && Util.curBillIndex <= Util.bills.size() - 1 && !hitBound:
		if Util.curBillIndex == 0:
			hitBound = true
			hitBoundL = true
		if Util.curBillIndex == Util.bills.size() - 1:
			hitBound = true
			hitBoundR = true
		print(Util.curBillIndex)

func _on_count_pressed():
	if !Util.bills[Util.curBillIndex].get_node("Counted").visible:
		Util.billsCounted += 1
		Util.countedTotal += int(Util.bills[Util.curBillIndex].get_denomination())
	Util.bills[Util.curBillIndex].get_node("Counted").visible = true
	if Util.billQuantity == Util.billsCounted:
		verify_counted.visible = true
	
	

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
		bundlePressed = true
		for n in Util.bundledQuantity:

			if Util.bills.is_empty():
				break
			elif Util.bills[0] in Util.bills:
					Util.bills[0].hide()
					Util.bills.remove_at(0)
		billIterater += 1
		var newBundle = BUNDLE.instantiate()
		moneyManagerMenu.add_child(newBundle)
		newBundle.position.x += 50 * billIterater


func select_cur_bill():
	
	#Util.bills[Util.curBillIndex].get_node("BillSelect").show()
	pass

func unselect_cur_bill():
	#Util.bills[Util.curBillIndex].get_node("BillSelect").hide()
	pass

func move_selected_bill(selectedBillIndex, targetIndex):
	var selectedBillDenomination = Util.bills[selectedBillIndex].get_denomination()
	var targetBillDenomination = Util.bills[targetIndex].get_denomination()
	selfSelectedBill = Util.bills[selectedBillIndex]
	selfTargetBill = Util.bills[targetIndex]

	if Util.bills[targetIndex].get_node("Counted").visible && Util.bills[selectedBillIndex].get_node("Counted").visible:
		Util.bills[targetIndex].get_node("Counted").visible = true
		Util.bills[selectedBillIndex].get_node("Counted").visible = true
	elif Util.bills[targetIndex].get_node("Counted").visible && !Util.bills[selectedBillIndex].get_node("Counted").visible:
		Util.bills[targetIndex].get_node("Counted").visible = false
		Util.bills[selectedBillIndex].get_node("Counted").visible = true
	elif !Util.bills[targetIndex].get_node("Counted").visible && Util.bills[selectedBillIndex].get_node("Counted").visible:
		Util.bills[targetIndex].get_node("Counted").visible = true
		Util.bills[selectedBillIndex].get_node("Counted").visible = false
	elif Util.bills[targetIndex].get_node("Counted").visible && Util.bills[selectedBillIndex].get_node("Counted").visible:
		Util.bills[targetIndex].get_node("Counted").visible = false
		Util.bills[selectedBillIndex].get_node("Counted").visible = false

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
		
