@tool
extends HBoxContainer


var hpFlames : Array[TextureRect]
@export_range(0,15,.1) var health :float= 15
var max_health = 15.0
var player: Player


func _ready() -> void:
	var flames_parent = $"."
	for child in flames_parent.get_children():
		hpFlames.append(child)
	
	if !player:
		player = get_tree().root.find_child("Player",true,false)
		
		
func _process(delta):
	if !player:
		player = get_tree().root.find_child("Player",true,false)
		
	if player:
		for i in range(hpFlames.size()):
			var flame : AnimatedSprite2D = hpFlames[i].get_node("FlameAnimation")
			var frac = (player.max_health/hpFlames.size())
			var thresh = frac * (i+1)
			var hp = player.health
			
			#print(thresh)
			if hp <= thresh - frac :
				flame.animation = "empty"
			elif hp <= thresh - frac + (frac * 2/3):
				flame.animation = "low"
			elif hp < thresh:
				flame.animation = "mid"
			else:
				flame.animation = "full"	
