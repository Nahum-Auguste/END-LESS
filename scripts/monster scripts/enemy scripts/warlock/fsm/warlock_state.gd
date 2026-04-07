class_name WarlockState extends State

var fsm: WarlockFSM

func _init(fsm: WarlockFSM):
	self.fsm = fsm
