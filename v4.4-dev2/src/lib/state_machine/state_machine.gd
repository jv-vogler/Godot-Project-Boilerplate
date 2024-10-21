@tool
class_name StateMachine extends Node

@export var INITIAL_STATE: State:
	set = _set_initial_state
@export var STATE_MEDIATOR: StateMediator:
	set = _set_state_mediator

var paused := false
var current_state: State
var previous_state: State


func init() -> void:
	paused = false
	update_configuration_warnings()
	change_state(INITIAL_STATE)

	if !STATE_MEDIATOR:
		return

	for child: State in STATE_MEDIATOR.get_children():
		var transition_to_signal_name: StringName = child.transition_to.get_name()
		child.connect(transition_to_signal_name, change_state)


func _input(event: InputEvent) -> void:
	if !current_state:
		return

	var new_state: State = current_state.input(event)
	if new_state:
		change_state(new_state)


func _process(delta: float) -> void:
	if !current_state:
		return

	var new_state: State = current_state.process(delta)
	if new_state:
		change_state(new_state)


func _physics_process(delta: float) -> void:
	if !current_state:
		return

	var new_state: State = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)


func change_state(new_state: State) -> void:
	if paused:
		return

	if new_state == null:
		return

	if current_state == new_state:
		return push_warning("new_state is the same as current_state, owner: %s" % [owner])

	if current_state:
		previous_state = current_state
		current_state.exit()

	current_state = new_state
	current_state.enter()


func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	var errors := {"has_state_children": false}

	if !INITIAL_STATE:
		warnings.push_back("StateMachine is missing an initial State assigned in the Inspector.")

	if !STATE_MEDIATOR:
		warnings.push_front("StateMachine is missing a StateMediator assigned in the Inspector.")

	for child in get_children():
		if child is State:
			errors.has_state_children = true

	if errors.has_state_children:
		warnings.push_front("States should be children of StateMediator instead.")

	return warnings


func _set_initial_state(value: State) -> void:
	INITIAL_STATE = value
	update_configuration_warnings()


func _set_state_mediator(value: StateMediator) -> void:
	STATE_MEDIATOR = value
	update_configuration_warnings()
