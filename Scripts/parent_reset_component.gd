extends ResetComponent
class_name ParentResetComponent

@export var parent_node : Node2D
var children : Array

func _ready() -> void:
	super._ready()
	
	# Put all the cashes in an array
	for child in parent_node.get_children():
		children.append(child)

func _process(delta: float) -> void:
	super._process(delta)

	# If all the cashes are gone then queue free the parent
	var flag := true
	for child in children:
		if child != null:
			flag = false
	
	if flag:
		parent.queue_free()
