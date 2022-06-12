extends KinematicBody

#stats
var saludAhora : int = 10
var saludMax : int = 10
var ammo : int = 15
var score : int = 0

#fisicas
var moveSpeed : float = 5.0
var jumpForce : float = 5.0
var gravity : float = 12.0

#camara
var minLookAngle : float = -90.0
var maxLookAngle : float = 90
var camaraSens : float  = .5


#vectores
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

#camara
onready var camera = get_node("CameraOrbit/Camera")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta: float) -> void:
	#Rotar la camara en el eje X
	camera.rotation_degrees -= Vector3(rad2deg(mouseDelta.y),0,0) * camaraSens * delta
	
	#Limitar la rotacion vertical
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	#Rotar el jugador en el eje Y
	rotation_degrees -= Vector3(0,rad2deg(mouseDelta.x),0)* camaraSens * delta	
	
	#reiniciar el mouse delta
	mouseDelta = Vector2()

	if is_moving():
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop()
	

	

func _physics_process(delta: float) -> void:
	#Reiniciar x y z de Velocidad cada cuadro
	vel.x = 0
	vel.z = 0
	
	var input = Vector2()
	
	#Input de movimiento
	if Input.is_action_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_pressed("ui_down"):
		input.y += 1
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_right"):
		input.x +=1
	
	input = input.normalized()
	
	var adelante = global_transform.basis.z
	var derecha = global_transform.basis.x
	
	#poner la velocidad
	vel.z = (adelante * input.y + derecha * input.x).z * moveSpeed
	vel.x = (adelante * input.y + derecha * input.x).x * moveSpeed
	
	vel.y -= gravity * delta
	
	vel = move_and_slide(vel, Vector3.UP)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
		

var footstep_profile : String

func set_footstep_profile(profile:String):
	footstep_profile = profile

func play_footstep_anim():
	if !is_on_floor():
		return
	var aud = $SoundFootstep#.get_child(int(foot))
	aud.stop()
	aud.stream = SndFootsteps.get_stepsound(footstep_profile) #singleton sound de footsteps
	aud.play()

func is_moving():
	#print(vel.abs().floor() != Vector3.ZERO)
	return is_on_floor() and vel.abs().floor() != Vector3.ZERO
