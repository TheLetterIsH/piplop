class_name Player
extends CharacterBody2D

# State Machine
enum State {
	NONE,
	IDLE,
	MOVE,
	DASH,
}

@export var state: State = State.NONE
var state_duration: float = 0.0
var previous_state_duration: float = 0.0

# Stats
# Movement
var move_speed: float = 12.5 * G.arena_unit
var friction: float = 0.15
var acceleration: float = 0.15

# Dash
var can_dash: bool = true
var dash_direction: Vector2 = Vector2.ZERO
var dash_speed: float = 40.0 * G.arena_unit
var dash_duration: float = 0.1
var dash_cooldown_duration: float = 2.0

# Knockback
var is_knockedback: bool = false
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_force: float = 150.0

# Health
var max_health: float = 100.0
var health: float = 100.0

# Attack
var multishot: int = 1
var attack_rate: float = 0.35
var projectile_range: float = 8.0
var projectile_speed: float = 18.0
var damage: float = 10.0
var damage_variance: float = 5.0
var crit_chance: float = 0.05
var crit_mult: float = 2.0

# Effects
var pierces: int = 0
var chains: int = 0

var can_return: bool = false
var can_seek: bool = false
var can_explode: bool = false

var can_inflict_decay: bool = false
var decay_delay: float = 0.5
var decay_ticks: int = 4
var decay_damage_multiplier: float = 0.8

## Multipliers
# Movement
var move_speed_multiplier: float = 1.0

# Health
var health_multiplier: float = 1.0

# Attack
var attack_rate_multiplier: float = 1.0
var projectile_range_multiplier: float = 1.0
var projectile_speed_multiplier: float = 1.0
var damage_multiplier: float = 1.0
var crit_chance_multiplier: float = 1.0
var crit_mult_multiplier: float = 1.0

# Chances

# Booleans
#var double_damage_on_return_hit: bool

var attack_count: int = 0
var _can_attack: bool = true

# References
var enemy_container: Node2D
var entity_container: Node2D

# Components
@onready var trigger: Trigger = $Trigger
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	initialize()
	connect_signals()


func initialize() -> void:
	# Set stats
	# passives_to_player()
	set_stats()
	
	# TODO Set references
	entity_container = InstanceManager.get_entity_container()
	
	change_state(State.IDLE)
	pass


func connect_signals() -> void:
	pass


func _process(_delta: float) -> void:
	if Input.is_action_pressed("attack"):
		if can_attack():
			attack()
			
			_can_attack = false
			trigger.after(attack_rate, func():
				_can_attack = true
			)


func _physics_process(delta: float) -> void:
	state_duration += delta
	
	match state:
		State.IDLE:
			idle_state()
		State.MOVE:
			move_state()
		State.DASH:
			dash_state()


func change_state(next_state: State) -> void:
	state = next_state
	state_duration = 0.0
	
	match state:
		State.IDLE:
			changed_to_idle_state()
		State.MOVE:
			changed_to_move_state()
		State.DASH:
			changed_to_dash_state()


#region STATS
# func passives_to_player() -> void:
# 	for key in Run.passives:
# 		var passive := Run.passives[key]
# 		var attributes := passive.attributes
# 		for attribute in attributes:
# 			print(attribute)
# 			var value = attributes[attribute]
# 			if !attribute in self:
# 				printerr("Attribute %s from Passive %s does not exist in %s",  [attribute, key, self.name])
# 				continue
# 			value = self.get(attribute) + value
# 			self.set(attribute, value)


func set_stats() -> void:
	# Movement
	
	# Health
	max_health = max_health * health_multiplier
	health = max_health
	
	# Attack
	
	pass
#endregion


#region MOVEMENT
func changed_to_idle_state() -> void:
	pass


func idle_state() -> void:
	var movement_direction := get_movement_direction_normalized()
	
	if movement_direction.length() > 0:
		change_state(State.MOVE)
		return
	
	if is_knockedback:
		self.velocity = knockback_direction * knockback_force
		move_and_slide()
		return
	
	self.velocity = self.velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()


func changed_to_move_state() -> void:
	pass


func move_state() -> void:
	var movement_direction := get_movement_direction_normalized()
	
	if can_dash and Input.is_action_just_pressed("dash") and movement_direction.length() > 0:
		dash_direction = movement_direction
		change_state(State.DASH)
		return
	
	if is_knockedback:
		self.velocity = knockback_direction * knockback_force
		move_and_slide()
		return
	
	if movement_direction.length() > 0:
		self.velocity = self.velocity.lerp(movement_direction * move_speed, acceleration)
	else:
		change_state(State.IDLE)
		return
	move_and_slide()


func changed_to_dash_state() -> void:
	var squash_direction := dash_direction.rotated(PI * 0.5)
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(sprite.material, "shader_parameter/squash_direction", squash_direction, 0.08)
	tween.tween_property(sprite.material, "shader_parameter/squash_direction", Vector2.ZERO, 0.1).from_current()
	
	# TODO Fire dashed event
	pass


func dash_state() -> void:
	velocity = velocity.lerp(dash_direction * dash_speed, acceleration)
	move_and_slide()
	
	if state_duration >= dash_duration:
		can_dash = false
		trigger.after(dash_cooldown_duration, func():
			can_dash = true
			# TODO Fire dash replenished event (can add signal to 'can_dash' variable)
		)
		change_state(State.MOVE)


func get_movement_direction_normalized() -> Vector2:
	var movement_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return movement_direction.normalized()
#endregion


#region ATTACK
func get_aim_direction_normalized() -> Vector2:
	var global_mouse_position := get_global_mouse_position()
	var aim_direction := Vector2.ZERO
	aim_direction = self.global_position.direction_to(global_mouse_position)
	return aim_direction.normalized()


func attack() -> void:
	attack_count += 1
	
	var target_direction := get_aim_direction_normalized()
	var projectile_instance := spawn_projectile(target_direction)
	entity_container.add_child(projectile_instance)
	
	# Effect
	var squash_direction := -target_direction
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(sprite.material, "shader_parameter/squash_direction", squash_direction, 0.08)
	tween.tween_property(sprite.material, "shader_parameter/squash_direction", Vector2.ZERO, 0.1).from_current()
	
	# TODO Play attack sound


func can_attack() -> bool:
	if !_can_attack:
		return false
	
	if state in [State.NONE, State.DASH]:
		return false
	
	return true


func spawn_projectile(target_direction: Vector2) -> Projectile:
	var projectile_scene := Repository.projectile_scene as PackedScene
	var projectile_instance := projectile_scene.instantiate() as Projectile

	target_direction = target_direction.rotated(randf_range(-PI/30, PI/30))
	
	projectile_instance.global_position = self.global_position
	projectile_instance.rotation = target_direction.angle()
	
	projectile_instance.range = projectile_range * G.arena_unit
	projectile_instance.speed = projectile_speed * G.arena_unit
	
	if randf() <= crit_chance:
		projectile_instance.is_crit = true
		damage *= crit_mult
	projectile_instance.damage = damage
	
	return projectile_instance
#endregion
