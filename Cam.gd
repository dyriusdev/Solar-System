extends Camera3D

const SHIFT_MULTIPLIER = 2.5
const ALT_MULTIPLIER = 1.0 / SHIFT_MULTIPLIER

@export_range(0, 1) var sensitivity : float = 0.25

var mousePosition : Vector2 = Vector2(0, 0)
var totalPitch : float = 0

var direction : Vector3 = Vector3(0, 0, 0)
var velocity : Vector3 = Vector3(0, 0, 0)
var acceleration : int = 30
var friction : int = -10
var multiplier : int = 4

var w : bool = false
var s : bool = false
var a : bool = false
var d : bool = false
var q : bool = false
var e : bool = false
var shift : bool = false
var alt : bool = false

func _input(event : InputEvent) -> void:
    if is_instance_of(event, InputEventMouseMotion):
        mousePosition = event.relative
    
    if is_instance_of(event, InputEventMouseButton):
        match event.button_index:
            MOUSE_BUTTON_RIGHT:
                Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.is_pressed() else Input.MOUSE_MODE_VISIBLE)
            MOUSE_BUTTON_WHEEL_UP:
                multiplier = clamp(multiplier * 1.1, 0.2, 20)
            MOUSE_BUTTON_WHEEL_DOWN:
                multiplier = clamp(multiplier / 1.1, 0.2, 20)
    
    if is_instance_of(event, InputEventKey):
        match event.keycode:
            KEY_W:
                w = event.is_pressed()
            KEY_S:
                s = event.is_pressed()
            KEY_A:
                a = event.is_pressed()
            KEY_D:
                d = event.is_pressed()
            KEY_Q:
                q = event.is_pressed()
            KEY_E:
                e = event.is_pressed()
    pass

func _process(delta : float) -> void:
    UpdateMoviment(delta)
    UpdateMouseLook()
    pass

func UpdateMoviment(delta : float) -> void:
    direction = Vector3(float(d) - float(a), float(e) - float(q), float(s) - float(w))
    
    var offset : Vector3 = direction.normalized() * acceleration * multiplier * delta + velocity.normalized() * friction * multiplier * delta
    
    var speed_multi : float = 1
    if shift:
        speed_multi *= SHIFT_MULTIPLIER
    if alt:
        speed_multi *= ALT_MULTIPLIER
    
    if direction == Vector3.ZERO and offset.length_squared() > velocity.length_squared():
        velocity = Vector3.ZERO
    else:
        velocity.x = clamp(velocity.x + offset.x, - multiplier, multiplier)
        velocity.y = clamp(velocity.y + offset.y, - multiplier, multiplier)
        velocity.z = clamp(velocity.z + offset.z, - multiplier, multiplier)
        translate(velocity * delta * speed_multi)
    pass

func UpdateMouseLook() -> void:
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        mousePosition *= sensitivity
        var yaw = mousePosition.x
        var pitch = mousePosition.y
        mousePosition = Vector2(0, 0)
        
        pitch = clamp(pitch, -90 - totalPitch, 90 - totalPitch)
        totalPitch += pitch
        rotate_y(deg_to_rad(-yaw))
        rotate_object_local(Vector3(1,0,0), deg_to_rad(-pitch))
    pass
