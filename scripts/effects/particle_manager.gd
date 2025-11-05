extends Node
## ParticleManager - Quản lý particle effects trong game

## Tạo particle effect tại vị trí
static func create_particle_effect(position: Vector3, type: String, parent: Node3D) -> GPUParticles3D:
	var particles = GPUParticles3D.new()
	particles.position = position
	particles.one_shot = true
	particles.explosiveness = 0.8

	match type:
		"harvest":
			_setup_harvest_particles(particles)
		"water":
			_setup_water_particles(particles)
		"till":
			_setup_till_particles(particles)
		"sparkle":
			_setup_sparkle_particles(particles)
		"money":
			_setup_money_particles(particles)
		"love":
			_setup_love_particles(particles)

	parent.add_child(particles)
	particles.emitting = true

	# Auto cleanup
	await parent.get_tree().create_timer(particles.lifetime).timeout
	particles.queue_free()

	return particles

## Harvest particles (leaves, sparkles)
static func _setup_harvest_particles(particles: GPUParticles3D) -> void:
	particles.amount = 20
	particles.lifetime = 1.0
	particles.explosiveness = 0.9

	var material = ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	material.emission_sphere_radius = 0.3
	material.direction = Vector3.UP
	material.spread = 45.0
	material.initial_velocity_min = 2.0
	material.initial_velocity_max = 4.0
	material.gravity = Vector3(0, -5, 0)
	material.color = Color(0.9, 0.9, 0.3, 1.0)
	material.scale_min = 0.1
	material.scale_max = 0.2

	particles.process_material = material

## Water splash particles
static func _setup_water_particles(particles: GPUParticles3D) -> void:
	particles.amount = 15
	particles.lifetime = 0.6

	var material = ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	material.emission_sphere_radius = 0.2
	material.direction = Vector3.UP
	material.spread = 30.0
	material.initial_velocity_min = 1.5
	material.initial_velocity_max = 3.0
	material.gravity = Vector3(0, -9.8, 0)
	material.color = Color(0.3, 0.6, 0.9, 0.7)
	material.scale_min = 0.05
	material.scale_max = 0.15

	particles.process_material = material

## Till soil particles (dirt)
static func _setup_till_particles(particles: GPUParticles3D) -> void:
	particles.amount = 12
	particles.lifetime = 0.8

	var material = ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	material.emission_sphere_radius = 0.3
	material.direction = Vector3.UP
	material.spread = 60.0
	material.initial_velocity_min = 1.0
	material.initial_velocity_max = 2.0
	material.gravity = Vector3(0, -5, 0)
	material.color = Color(0.4, 0.3, 0.2, 1.0)
	material.scale_min = 0.08
	material.scale_max = 0.15

	particles.process_material = material

## Sparkle particles (success, collect)
static func _setup_sparkle_particles(particles: GPUParticles3D) -> void:
	particles.amount = 30
	particles.lifetime = 1.2
	particles.explosiveness = 1.0

	var material = ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	material.emission_sphere_radius = 0.5
	material.direction = Vector3.UP
	material.spread = 180.0
	material.initial_velocity_min = 0.5
	material.initial_velocity_max = 2.0
	material.gravity = Vector3(0, -2, 0)
	material.color = Color(1.0, 0.9, 0.3, 1.0)
	material.scale_min = 0.05
	material.scale_max = 0.1

	particles.process_material = material

## Money collect particles
static func _setup_money_particles(particles: GPUParticles3D) -> void:
	particles.amount = 10
	particles.lifetime = 0.8

	var material = ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	material.emission_sphere_radius = 0.3
	material.direction = Vector3.UP
	material.spread = 30.0
	material.initial_velocity_min = 2.0
	material.initial_velocity_max = 3.0
	material.gravity = Vector3(0, -3, 0)
	material.color = Color(1.0, 0.8, 0.0, 1.0)
	material.scale_min = 0.1
	material.scale_max = 0.15

	particles.process_material = material

## Love/happiness particles (animals)
static func _setup_love_particles(particles: GPUParticles3D) -> void:
	particles.amount = 8
	particles.lifetime = 1.5

	var material = ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	material.emission_sphere_radius = 0.2
	material.direction = Vector3.UP
	material.spread = 20.0
	material.initial_velocity_min = 0.5
	material.initial_velocity_max = 1.0
	material.gravity = Vector3(0, -1, 0)
	material.color = Color(1.0, 0.3, 0.5, 1.0)
	material.scale_min = 0.15
	material.scale_max = 0.25

	particles.process_material = material

## Create rain effect
static func create_rain(parent: Node3D, intensity: float = 1.0) -> GPUParticles3D:
	var rain = GPUParticles3D.new()
	rain.amount = int(500 * intensity)
	rain.lifetime = 2.0
	rain.visibility_aabb = AABB(Vector3(-50, 0, -50), Vector3(100, 30, 100))

	var material = ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	material.emission_box_extents = Vector3(50, 0, 50)
	material.direction = Vector3(0, -1, 0.1)
	material.spread = 0.0
	material.initial_velocity_min = 10.0
	material.initial_velocity_max = 12.0
	material.gravity = Vector3(0, -20, 0)
	material.color = Color(0.7, 0.8, 1.0, 0.3)
	material.scale_min = 0.02
	material.scale_max = 0.04

	rain.process_material = material
	rain.draw_pass_1 = _create_rain_mesh()

	parent.add_child(rain)
	rain.emitting = true

	return rain

static func _create_rain_mesh() -> Mesh:
	var mesh = BoxMesh.new()
	mesh.size = Vector3(0.02, 0.3, 0.02)
	return mesh
