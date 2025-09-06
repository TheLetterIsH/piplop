class_name Projectile
extends Area2D

# Externals
# var player: Player
# var enemy_container: EnemyContainer
# var effect_container: Node2D

# Stats
var range: float
var speed: float
var damage: float
var is_crit: bool

# Behaviour
var pierces: int
var chains: int
var bounces: int
var can_seek: bool
var can_explode: bool

# Effects
var can_inflict_poison: bool
var poision_delay: float
var poision_times: int
var poision_damage: float

var move_direction: Vector2
var distance_travelled: float

var chained_enemies_hit: Array = []

# Components
@onready var trigger: Trigger = $Trigger
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	initialize()
	connect_signals()


func initialize() -> void:
    # player = InstanceManager.get_player()
    # enemy_container = InstanceManager.get_enemy_container()
    # effect_container = InstanceManager.get_effect_container()
	pass


func connect_signals() -> void:
	area_entered.connect(on_area_entered)
	body_entered.connect(on_body_entered)


func _physics_process(delta: float) -> void:
	#sprite.rotation += PI * delta
	# if can_seek:
	# 	var closest_enemy := enemy_container.get_closest_enemy_in_radius(range, [], self)
	# 	if closest_enemy:
	# 		var target_direction := self.global_position.direction_to(closest_enemy.global_position)
	# 		self.rotation = lerp_angle(self.rotation, target_direction.angle(), 10 * delta)
	move_direction = Vector2.RIGHT.rotated(self.rotation)
	self.position += move_direction * speed * delta
	
	distance_travelled += speed * delta
	if distance_travelled >= range:
		die()


func on_area_entered(other_area: Area2D) -> void:
	if pierces <= 0 and chains <= 0:
		die()
	
	# if chains > 0:
	# 	chains -= 1
	# 	chained_enemies_hit.append(other_area.owner)
	# 	var closest_enemy := enemy_container.get_closest_enemy_in_radius(range, chained_enemies_hit, self)
	# 	if closest_enemy:
	# 		var target_direction := self.global_position.direction_to(closest_enemy.global_position)
	# 		self.rotation = target_direction.angle()
	# 	if can_seek:
	# 		can_seek = false
	# elif pierces > 0:
	# 	pierces -= 1
	# 	if can_seek:
	# 		can_seek = false
	
	# var enemy := other_area.owner as Enemy
	# if enemy:
	# 	enemy.take_damage(self, damage)


func on_body_entered(other_body: Node2D) -> void:
	die()


func die() -> void:
	# Effects
	# var particles_scene := Repository.particles_projectile_death as PackedScene
	# var particles_instance := particles_scene.instantiate() as GPUParticles2D
	# particles_instance.global_position = self.global_position
	# particles_instance.rotation = (-move_direction).angle()
	# particles_instance.emitting = true
	# particles_instance.finished.connect(func():
	# 	particles_instance.queue_free()
	# )
	# effect_container.add_child(particles_instance)
	
	queue_free()
