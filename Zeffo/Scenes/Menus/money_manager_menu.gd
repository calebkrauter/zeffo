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
@onready var skipLeftBtn = $SkipLeft
@onready var skipRightBtn = $SkipRight
@onready var controls = [arrowRightBtn, selectBtn, arrowLeftBtn, countBtn, flipBtn, bundleBtn, skipLeftBtn, skipRightBtn]
var slideOffset = Util.bundledQuantity
@onready var selector = $"../../.."
var selfTargetBill
var selfSelectedBill
var bundleBtnPressed = false
@onready var movable = $Movable
@onready var bundle2d = $Bundle2D
const BUNDLE = preload("res://Scenes/Entities/bundle.tscn")
#var billLayoutContainer = Stage1OG.newBillLayout
@onready var moneyManagerMenu = $"."
var dontStartNewBundle = false
var firstOfSelectBundle = false
var selectBundleAmt = 0
var selectAndBundlePressed = false
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
var additive = 0
@onready var verify_counted = $"../../VerifyCounted"
# Called when the node enters the scene tree for the first time.
func _ready():
	prevSelectorPos = selector.position.x
	selfDelta = 0
	prevBillPos = selector.position.x
	await get_tree().process_frame
	selfTargetBill = Util.bills[Util.curBillIndex]
	selfSelectedBill = Util.bills[Util.curBillIndex]
	verify_counted.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	selfDelta = delta
	if Util.curBillIndex > Util.bills.size() - 1:
		Util.curBillIndex = Util.bills.size() - 1
	if !Util.bills.is_empty():
		curBillRelativePosition = Util.bills[Util.curBillIndex].position.x - Util.billPosXOffset - Util.startingIndexBillPosXOffset
		controls_disabled(false)
		Util.is_in_bill_array_bounds()

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
	if bundleBtnPressed && selector.position.x >= curBillRelativePosition:
		var varianceOffset = abs(selector.position.x - curBillRelativePosition)
		for n in Util.bills.size():
			Util.bills[n].position.x += varianceOffset
			Util.bills[n].get_node("Bill2D").scale = Vector2(0.4, 0.4)
		bundleBtnPressed = false
	if bundleBtnPressed && curBillRelativePosition != selector.position.x:
		for n in Util.bills.size():
			Util.bills[n].position.x -= 5000 * delta
			Util.bills[n].get_node("Bill2D").scale = Vector2(0.38, 0.38)

func slide_selector(delta):
	if direction == 1 && rightPressed:
		if selector.position.x < prevSelectorPos + Util.billMarginX * direction:
			selector.position.x += direction * delta * Util.speedToMove * Util.speedMultiplier
			if selector.position.x >= prevSelectorPos + Util.billMarginX * direction:
				selector.position.x = prevSelectorPos + Util.billMarginX * direction
				print(prevSelectorPos + Util.billMarginX * direction)
		else:
			prevSelectorPos = selector.position.x
			rightPressed = false
	elif direction == -1 && leftPressed:
		if selector.position.x > prevSelectorPos + Util.billMarginX * direction:
			selector.position.x += direction * delta * Util.speedToMove * Util.speedMultiplier
			if selector.position.x <= prevSelectorPos + Util.billMarginX * direction:
				selector.position.x = prevSelectorPos + Util.billMarginX * direction
				print(prevSelectorPos + Util.billMarginX * direction)
		else:
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
	if !selectBtnPressed:
		selectBtnPressed = true
		Util.bills[Util.curBillIndex].isSelected = true
	else:
		selectBtnPressed = false
		Util.bills[Util.curBillIndex].isSelected = false

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

func _on_bundle_pressed():
	var billsBundled = 0
	var miscountChance = 0
	var miscountedBillDenominations = []
	var dynamicBundledQuantity = Util.bundledQuantity
	var newBundleStarted = false
	var tempBundleToCheckSorted = []
	if !Util.bills.is_empty():
		bundleBtnPressed = true
		var numOfBillsMiscounted = 0
		var foundBillNotCounted = false
		var billIndexToRemove = 0
		if !selectBtnPressed:
			if dynamicBundledQuantity <= Util.bundledQuantity && dynamicBundledQuantity < 10:
				dynamicBundledQuantity = Util.bills.size()
			for n in Util.bundledQuantity:
				if Util.bills.is_empty():
					break
				if n >= Util.bills.size():
					break
				Util.grandTotal += int(Util.bills[n].get_denomination())
				
				if !Util.bills[n].get_node("Counted").visible && !foundBillNotCounted:
					numOfBillsMiscounted = randi_range(0, 4)
					if numOfBillsMiscounted > Util.billQuantity:
						numOfBillsMiscounted = Util.billQuantity
					dynamicBundledQuantity -= numOfBillsMiscounted

					for m in numOfBillsMiscounted:
						if n + m >= Util.bundledQuantity - 1:
							break
						else:
							miscountedBillDenominations.append(int(Util.bills[n + m].get_denomination()))
					foundBillNotCounted = true
		else:
			Util.grandTotal += int(Util.bills[Util.curBillIndex].get_denomination())
			countBtn.emit_signal("pressed")
			selectBtn.emit_signal("pressed")
			dynamicBundledQuantity = 1
			billIndexToRemove = Util.curBillIndex
			selectAndBundlePressed = true
			
			if selectBundleAmt >= Util.bundledQuantity :
				dontStartNewBundle = false
				firstOfSelectBundle = true
				selectBundleAmt = 0
			else:
				firstOfSelectBundle = false
			selectBundleAmt += 1

		for n in dynamicBundledQuantity:
			if Util.bills.is_empty():
				break
			tempBundleToCheckSorted.append(Util.bills[billIndexToRemove])
			billsBundled += 1
			if selectAndBundlePressed:
				billsBundled = selectBundleAmt
			if Util.bills[billIndexToRemove] in Util.bills:
				Util.bills[billIndexToRemove].hide()
				add_score(Util.bills[billIndexToRemove], tempBundleToCheckSorted, n)
				Util.bills.remove_at(billIndexToRemove)
				newBundleStarted = true
		if newBundleStarted && !dontStartNewBundle:
			if !selectAndBundlePressed || firstOfSelectBundle:
				billIterater += 1
			var newBundle = BUNDLE.instantiate()
			moneyManagerMenu.add_child(newBundle)
			newBundle.position.x += 50 * billIterater
			if firstOfSelectBundle:
				dontStartNewBundle = true
		if selectAndBundlePressed:
			for n in Util.curBillIndex:
				Util.bills[n].position.x += 100
			selectAndBundlePressed = false
	additive = 0
	check_sorted(tempBundleToCheckSorted)
	calculate_score()

func calculate_score():
	Util.score += (Util.scoreFromBundle * Util.weightBundleScore 
	+ Util.scoreFromCount * Util.weightCountScore
	+ Util.scoreFromHeads * Util.weightHeadsScore
	+ Util.scoreFromSort * Util.weightSortScore)
	print(Util.score, " TOTAL SCORE")

func check_sorted(array):
	for n in array.size():
		if !(n + 1 <= array.size() - 1):
			break
		if array[n].get_denomination() >= array[n + 1].get_denomination():
			additive += 1
		else:
			additive = 0
			return
	Util.scoreFromSort += additive
	#print(additive, " sorted")

func add_score(curBill, tempBundleToCheckSorted, n):
	Util.scoreFromBundle += 1
	if curBill.get_node("Bill2D").frame == 1:
		Util.scoreFromHeads += 1
	if curBill.get_node("Counted").visible:
		Util.scoreFromCount += 1
	#print(Util.scoreFromBundle, " bundled")
	#print(Util.scoreFromHeads, " heads up")
	#print(Util.scoreFromCount, " counted")


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
		


func _on_keep_pressed():
	for n in Util.bills.size():
		if Util.bills.is_empty():
			break

		if Util.bills[0] in Util.bills:
			Util.keptCash += int(Util.bills[0].get_denomination())
			Util.bills[0].hide()
			Util.bills.remove_at(0)
		var newBundle = BUNDLE.instantiate()
		moneyManagerMenu.add_child(newBundle)
		newBundle.position.x += 440
		newBundle.position.y += 460

var speedHigh = false

func _on_change_speed_pressed():
	if !speedHigh:
		Util.speedMultiplier = 3
		speedHigh = true
	else:
		Util.speedMultiplier = 1
		speedHigh = false


func _on_skip_right_pressed():
	#Util.speedMultiplier = 10
	#for n in 8:
		#rightPressed = true
		#slide_selector(selfDelta)
		#arrowRightBtn.emit_signal("pressed")
	#Util.curBillIndex += -4
	#Util.speedMultiplier = 1
	pass


func _on_skip_left_pressed():
	#Util.speedMultiplier = 10
	#for n in 9:
		#leftPressed = true
		#slide_selector(selfDelta)
		#arrowLeftBtn.emit_signal("pressed")
	##Util.curBillIndex += 1
	#Util.speedMultiplier = 1
	pass
