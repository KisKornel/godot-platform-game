extends CharacterBody2D

var walk_speed: int = 150
var run_speed: int = 250
var jump_speed: int = -450
var damage: int = 10
var max_hp: int = 100
var is_attacking: bool = false
var is_dying: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var health_bar: TextureProgressBar = $TextureProgressBar
@onready var player_sprite_2d: AnimatedSprite2D = $PlayerSprite2D
@onready var attack_pivot: Node2D = $AttackPivot
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var jumpSound: AudioStreamPlayer2D = $Jump
@onready var attackSound: AudioStreamPlayer2D = $Attack
@onready var deathSound: AudioStreamPlayer2D = $Death

func _ready() -> void:
	set_health()
	
func _physics_process(delta: float) -> void:
	if is_attacking or is_dying:
		return
		
	var run = Input.is_action_pressed('run')
	var direction = Input.get_axis("move_left", "move_right")
		
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		jumpSound.playing = true
		
	#Flip the Sprite
	if direction > 0:
		player_sprite_2d.flip_h = false
		attack_pivot.scale.x = 1.0
	elif direction < 0:
		player_sprite_2d.flip_h = true
		attack_pivot.scale.x = -1.0
		
	# Play animations
	if is_on_floor():
		if direction == 0:
			player_sprite_2d.play("idle")
		else:
			if run:
				player_sprite_2d.play("run")
			else:
				player_sprite_2d.play("walk")
	else:
		player_sprite_2d.play("jump")
	
	# Apply movement
	if direction:
		if run:
			velocity.x = direction * run_speed
		else:
			velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		
	move_and_slide()
	
	if Input.is_action_just_pressed("attack") and is_on_floor():
		start_attack()

func set_health() -> void:
	health_bar.max_value = max_hp
	health_bar.value = Game.playerHP
	
func start_attack() -> void:
	is_attacking = true
	velocity = Vector2.ZERO
	anim.play("attack")
	attackSound.playing = true

func _on_hit_box_body_entered(body: Node2D) -> void:
	if is_dying:
		return
		
	if body.is_in_group("enemies"):
		if body.has_method("apply_damage"):
			body.apply_damage(damage)

func apply_damage(amount: int) -> void:
	if is_dying:
		return
		
	Game.playerHP -= amount
	var tween = create_tween()
	tween.tween_property(health_bar, "value", Game.playerHP, 0.2).set_trans(Tween.TRANS_SINE)
	if Game.playerHP <= 0:
		die()
		
func health(amount: int) -> void:
	Game.playerHP = min(Game.playerHP + amount, 100)
	var tween = create_tween()
	tween.tween_property(health_bar, "value", Game.playerHP, 0.2).set_trans(Tween.TRANS_SINE)

func die():
	is_dying = true
	texture_progress_bar.visible = false
	anim.play("dead")
	deathSound.playing = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false
		player_sprite_2d.play("idle")
	if anim_name == "dead":
		get_tree().reload_current_scene()
		Utils.reset_save_point()
