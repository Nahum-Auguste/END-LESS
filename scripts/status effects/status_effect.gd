@tool
@abstract class_name StatusEffect extends Resource

var finished = false
var active: bool = false
var tick_interval_timer: Timer
var tick_count :int = 0
@export var name: String
@export_range(1,100,1) var max_ticks: int = 1
@export_range(0,15,.1) var tick_interval: float = 0


func apply(user: Monster) -> void:
	# set up timer and add it to the user
	if tick_interval and !tick_interval_timer and !finished and user:
		print("status effect timer created")
		tick_interval_timer = Timer.new()
		tick_interval_timer.one_shot = false
		tick_interval_timer.wait_time = tick_interval
		tick_interval_timer.timeout.connect(func (): 
			if tick_count < max_ticks:
				_on_apply(user)
				tick_count+=1
			else:
				finish()
		)
		user.add_child(tick_interval_timer)
	
	
	# activate when this function is called if its not finished. Else, deactivate it
	if !finished:
		active = true
	else:
		finish()
	
	# if active, start the timer if its been stopped.
	if active:
		if tick_interval_timer and tick_interval_timer.is_stopped():
			tick_interval_timer.start()
			
		if tick_interval == 0 and tick_count == 0:
			_on_apply(user)
			tick_count += 1
			
			
	if tick_count>=max_ticks:
		finished = true
		active = false
		
		
	
func finish():
	if tick_interval_timer:
		tick_interval_timer.queue_free()
	finished = true
	active = false
		
func is_finished() -> bool:
	return finished
		

func clone():
	var effect = self.get_script().new()
	for p in get_property_list():
		if !(p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) : continue 
		effect[p.name] = self[p.name]
	return effect

@abstract func _on_apply(user: Monster) -> void
