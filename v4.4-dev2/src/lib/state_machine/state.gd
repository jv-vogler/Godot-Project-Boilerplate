@tool
class_name State extends Node

signal transition_to(new_state: State)


func enter() -> void:
	pass


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(_delta: float) -> State:
	return null
