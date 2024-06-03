'''
This class represent all celestial bodies in the game
here you will find all the maths for gravity interactions
'''
class_name CelestialBody extends RigidBody3D

@export var initialVelocity : Vector3 = Vector3.ZERO
@export var isSun : bool = false

const G : float = 6.6743 * pow(10, -2)

func _ready() -> void:
    linear_velocity = initialVelocity
    Globals.celestialBodies.append(self)
    pass

func _physics_process(_delta : float) -> void:
    if not isSun:
        Gravity()
    else:
        linear_velocity = Vector3.ZERO
    pass

func Gravity() -> void:
    for otherBody in Globals.celestialBodies:
        if otherBody != self:
            var direction : Vector3 = position - otherBody.position
            var distance : float = direction.length()

            var forceMag : float = G * ((mass * otherBody.mass) / (distance * distance))
            var force : Vector3 = direction.normalized() * forceMag
            add_constant_central_force(-force)
    pass