class_name Imbuement extends Resource

@export_range(0,1,.05) var proc_chance: float = 0

@export var imbuements: Array[Imbuement] = []


func try_proc(body: Monster = null):
	if randf_range(0,.9) <= proc_chance:
		proc(body)


# forcefully proc
func proc(body: Monster = null):
	on_proc(body)


func on_proc(body: Monster = null):
	pass
