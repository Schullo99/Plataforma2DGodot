extends CharacterBody2D
const SPEED = 10.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var fall_detect: RayCast2D = $FallDetect
@onready var playerdetect: RayCast2D = $playerdetect
@onready var attack_area: Area2D = $attackArea

var direction = 1

enum Enemystate{
	walking,
	dead,
	attack
}

var currentstate: Enemystate
func _ready() -> void:
	start_walking()
	
func _physics_process(delta: float) -> void:
	
	match currentstate:
		Enemystate.walking:
			walking()
		Enemystate.attack:
			atack()
		Enemystate.dead:
			dead()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	

		
	
	move_and_slide()
	
func start_walking():
	currentstate = Enemystate.walking
	velocity.x = 0;
	
		
func walking():
	if !fall_detect.is_colliding():
		direction = direction * -1
		scale.x *= -1
	velocity.x = SPEED * direction

	if playerdetect.is_colliding():
		start_attack()	
		
func start_attack():
	currentstate = Enemystate.attack
	anim.play("attack")
	velocity.x = 0
	
func atack():
	if	anim.frame == 2:
		attack_area.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		attack_area.process_mode = Node.PROCESS_MODE_DISABLED
		
func dead():
	pass
func going_dead():
	currentstate = Enemystate.dead 
	velocity.x = 0
	anim.play("dead")
	hitbox.queue_free()
	
func take_damage():
	going_dead()
	


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		start_walking()
