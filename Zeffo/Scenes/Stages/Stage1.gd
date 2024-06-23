extends Node2D
const BILL_LAYOUT_CONTAINER = preload("res://Scenes/EntitiyContainerScenes/bill_layout_container.tscn")
@onready var bills = $BillsFrame/BillsControl
# Called when the node enters the scene tree for the first time.

# Called when the node enters the scene tree for the first time.
func _ready():
	var newBillLayout = BILL_LAYOUT_CONTAINER.instantiate()
	bills.add_child(newBillLayout)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
