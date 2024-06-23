extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	select_cur_bill()




func _on_select_pressed():
	select_cur_bill()


func _on_arrow_left_pressed():
	unselect_cur_bill()
	Util.curBillIndex -= 1

func _on_arrow_right_pressed():
	unselect_cur_bill()
	Util.curBillIndex += 1

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
	
	
