

var status_effects: Array[StatusEffect] = []

func _init(id :int, name: String, max_stack_count :int):
	super(id,name,max_stack_count)
	
func set_status_effects(effects: Array[StatusEffect]):
	status_effects = []
	for i in range(effects.size()):
		var e = effects[i].duplicate()
		status_effects.push_back(e)
	
	
func consume(user: Monster):
	for e in status_effects:
		if e:
			user.add_status_effect(e)
		
	count = clamp(count-1,0,max_stack_count)
	if count == 0:
		free.call_deferred()
		for e in status_effects:
			if e:
				e.free.call_deferred()
		
