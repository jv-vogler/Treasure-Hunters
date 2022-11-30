extends MoveState


func input(event: InputEvent) -> BaseState:
	var new_state = super.input(event)
	if new_state:
		return new_state

	return null
