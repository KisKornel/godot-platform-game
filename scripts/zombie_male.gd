extends CharacterBody2D

var walk_speed: int = 60
var run_speed: int = 100
var max_hp: int = 30
var current_hp: int = 30
var direction: int = 1
var attack_distance: int = 10
var damage: int = 10
var is_attacking: bool = false
var is_dying: bool = false
var chase: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var health_bar: TextureProgressBar = $TextureProgressBar
@onready var zombie_male_srite_2d: AnimatedSprite2D = $ZombieMaleSrite2D
@onready var attack_pivot: Node2D = $AttackPivot
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D = $"../../Player"
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var player_detector: CollisionShape2D = $PlayerDetector/CollisionShape2D
@onready var attackSound: AudioStreamPlayer2D = $Attack
@onready var deathSound: AudioStreamPlayer2D = $Death
@onready var ui: CanvasLayer = %UI

func _ready() -> void:
	set_health()

func _physics_process(delta: float) -> void:
	if is_attacking or is_dying:
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if chase == true:
		var dis = global_position.distance_to(player.global_position)
		if dis < attack_distance:
			attack()
			return
		
		var dir = global_position.direction_to(player.global_position)
		
		if dir.x > 0:
			zombie_male_srite_2d.flip_h = false
			attack_pivot.scale.x = 1.0
			direction = 1
		else:
			zombie_male_srite_2d.flip_h = true
			attack_pivot.scale.x = -1.0
			direction = -1
		velocity.x = dir.x * run_speed
	else:
		if ray_cast_left.is_colliding():
			direction = 1
			zombie_male_srite_2d.flip_h = false
			attack_pivot.scale.x = -1.0
		if ray_cast_right.is_colliding():
			direction = -1
			zombie_male_srite_2d.flip_h = true
			attack_pivot.scale.x = 1.0
		position.x += direction * walk_speed * delta
		
	zombie_male_srite_2d.play("walk")
	move_and_slide()
	
func set_health() -> void:
	health_bar.max_value = max_hp
	health_bar.value = current_hp
	
func attack() -> void:
	is_attacking = true
	velocity = Vector2.ZERO
	anim.play("attack")
	attackSound.playing = true
	
func apply_damage(amount: int) -> void:
	if is_dying:
		return
		
	current_hp -= amount
	var tween = create_tween()
	tween.tween_property(health_bar, "value", current_hp, 0.2).set_trans(Tween.TRANS_SINE)
	
	if current_hp <= 0:
		die()		
	
func die():
	ui.add_point(5)
	is_dying = true
	texture_progress_bar.visible = false
	anim.play("dead")
	deathSound.playing = true
	
func _on_hit_box_body_entered(body: Node2D) -> void:
	if is_dying: 
		return
			
	if body.name == "Player" and body.is_dying == false:
		if body.has_method("apply_damage"):
			body.apply_damage(damage)
	else:
		player_detector.disabled = true
		chase = false
		zombie_male_srite_2d.play("idle")

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false
	if anim_name == "dead":
		queue_free()
