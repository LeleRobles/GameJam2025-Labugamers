extends Camera2D

@export var zoomSpeed : float = 10;
var zoomTarget :Vector2

var dragStartMOusePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false

func _ready() -> void:
	zoomTarget = zoom
	pass
	
func _process(delta: float) -> void:
	Zoom(delta)
	SimplePan(delta)
	ClickAndDrag()
	
func Zoom(delta):
	if Input.is_action_just_pressed("ScrollMouseCima"):
		zoomTarget *= 1.1
	if Input.is_action_just_pressed("ScrollMouseBaixo"):
		zoomTarget *= 0.9
	
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)

func SimplePan(delta):
	var moveAmount = Vector2.ZERO
	if Input.is_action_pressed("Camera_move_right"):
		moveAmount.x += 1
	if Input.is_action_pressed("Camera_move_left"):
		moveAmount.x -= 1
	if Input.is_action_pressed("Camera_move_up"):
		moveAmount.y -= 1
	if Input.is_action_pressed("Camera_move_down"):
		moveAmount.y += 1
		
	moveAmount = moveAmount.normalized()
	position  += moveAmount * delta * 1000 * (1/zoom.x)
	

func ClickAndDrag():
	if !isDragging and Input.is_action_just_pressed("Camera_pan"):
		dragStartMOusePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
	if isDragging and Input.is_action_just_released("Camera_pan"):
		isDragging = false
	
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMOusePos
		position = dragStartCameraPos - moveVector * 1/zoom.x
