#@tool 
class_name ElderWarlockFSM extends FSM

var parent: ElderWarlock
var player: Player
@export var idle_state: IdleState
@export var wander_state: WanderState
@export var close_range_attack: ElderWarlockAttackState
@export var mid_range_attack: ElderWarlockAttackState
@export var far_range_attack: ElderWarlockAttackState
@export var teleport: TeleportState
@export var teleport_barrage: TeleportState
@export var clone_state: ElderWarlockCloneState
@export_range(0,500,1) var close_range_attack_range: float = 100
@export_range(0,500,1) var mid_range_attack_range: float = 150
@export_range(0,500,1) var far_range_attack_range: float = 300
var phase: int = 1
var playing_theme = false

func _ready():
	super._ready()
	parent = get_parent()
	nav_agent.target_position = parent.global_position
	enter_state(idle_state)
	#
	#if !parent.is_clone():
		#enter_state(clone_state)
	


func physics_update(delta):
	super.physics_update(delta)
	var real_warlock: ElderWarlock = parent.real_warlock
	
	#print(current_state)
	
	if !parent.is_clone() and parent.health<= parent.max_health/2 and phase==1:
		phase = 2
		enter_state(clone_state)
	
	
	
	if parent.player and !parent.is_detection_ray_blocked():
		player = parent.player
		parent.detection_area_shape.radius = mid_range_attack_range
		if playing_theme == false and !parent.is_clone():
			playing_theme = true
			
			if body.real_warlock == body:
				var theme_player: AudioStreamPlayer = LevelManager.audio_player
				var music : AudioStreamWAV = load("res://assets/music/early_elder_warlock_battle_theme.wav")
				music.loop_mode = AudioStreamWAV.LOOP_FORWARD
				if theme_player:
					theme_player.stream = music
					theme_player.play()
	
	if player:
		if current_state is not TeleportState and current_state is not ElderWarlockCloneState:
			if is_player_in_range(close_range_attack_range):
				enter_state(close_range_attack)
			elif is_player_in_range(mid_range_attack_range):
					enter_state(mid_range_attack)
			elif is_player_in_range(far_range_attack_range):
				enter_state(far_range_attack)
			elif nav_agent.is_navigation_finished() and current_state != wander_state:
				player = null
				parent.player = null
				enter_state(wander_state)
				
				
	if parent.is_clone() and real_warlock:
		if current_state == clone_state:
			exit_state()
		if real_warlock.fsm.current_state != real_warlock.fsm.teleport_barrage:
			if current_state == teleport_barrage:
				exit_state()
		else:
			enter_state(teleport_barrage)

		if player:
			real_warlock.fsm.player = player
			real_warlock.player = player
	
	
	if current_state is AttackState and is_player_in_range(far_range_attack_range):
		nav_agent.target_position = player.global_position
		
	
	
	
func is_player_in_range(range: float):
	return player and parent.global_position.distance_to(player.global_position) <= range*parent.scale.x
	
func draw():
	super.draw()
	parent.draw_circle(Vector2.ZERO,wander_state.min_wander_range,Color.WHEAT,false)
	parent.draw_circle(Vector2.ZERO,wander_state.max_wander_range,Color.WHEAT,false)
	parent.draw_circle(Vector2.ZERO,parent.detection_area_shape.radius,Color(Color.YELLOW,.2),true)
	parent.draw_circle(Vector2.ZERO,close_range_attack_range,Color.YELLOW,false)
	parent.draw_circle(Vector2.ZERO,mid_range_attack_range,Color.ORANGE,false)
	parent.draw_circle(Vector2.ZERO,far_range_attack_range,Color.RED,false)



func _on_hurt_box_area_entered(area: Area2D):
	if $FleeTimer.is_stopped():
		$FleeTimer.start()


func _on_flee_timer_timeout():
	if current_state is not ElderWarlockCloneState:
		enter_state(teleport)
