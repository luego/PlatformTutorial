extends KinematicBody2D

const SPEED = 60
const GRAVITY = 10
const JUMP_FORCE = -250
const FLOOR = Vector2(0, -1)
const FIREBALL = preload("res://Fireball.tscn")

var velocity = Vector2()
var is_attacking =  false

onready var sprite = $AnimatedSprite

func _physics_process(delta):
	
	var check_floor = is_on_floor()
	
	if Input.is_action_pressed("ui_right"):
		if is_attacking == false or check_floor == false:
			velocity.x = SPEED
			if is_attacking == false:
				sprite.flip_h = false
				sprite.play("Run")
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
	elif Input.is_action_pressed("ui_left"):
		if is_attacking == false or check_floor == false:
			velocity.x = -SPEED
			if is_attacking == false:
				sprite.flip_h = true
				sprite.play("Run")
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
	else:
		velocity.x = 0
		if check_floor and is_attacking == false:
			sprite.play("Idle")
	
	if Input.is_action_pressed("ui_up"):
		if is_attacking == false and check_floor:
			velocity.y = JUMP_FORCE		
	print( Input.is_action_just_pressed("ui_accept"))
	if Input.is_action_just_pressed("ui_accept") && is_attacking == false:
		if check_floor:
			velocity.x = 0
		is_attacking = true
		sprite.play("Attack")
		var fireball = FIREBALL.instance()
		
		if sign($Position2D.position.x) == 1:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position
		
	velocity.y += GRAVITY
		
	if check_floor:
		is_attacking = false
	else:
		if is_attacking == false:
			if velocity.y < 0:
				sprite.play("Jump")
			else:
				sprite.play("Fall")
	
	velocity = move_and_slide(velocity, FLOOR,true)
	
func _on_AnimatedSprite_animation_finished():
	is_attacking = false
