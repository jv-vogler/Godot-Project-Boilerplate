@tool
class_name StateMediator extends Node


func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	var errors := {"invalid_children": false}

	for child in get_children():
		if !child is State:
			errors.invalid_children = true

	if errors.invalid_children:
		warnings.push_front("StateMediator only supports State as children")

	return warnings
