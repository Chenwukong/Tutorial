extends TextureRect

var mask_image: Image
var mask_texture: ImageTexture

@export var brush_size = 100

func _ready():
	call_deferred("setup_mask")
	call_deferred("setup_shader")

func setup_mask():
	if size == Vector2.ZERO:
		call_deferred("setup_mask")
		return
	mask_image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	mask_image.fill(Color.BLACK)
	mask_texture = ImageTexture.new()
	mask_texture.set_image(mask_image)

func setup_shader():
	if mask_texture == null:
		call_deferred("setup_shader")
		return
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://刮刮乐.gdshader")
	shader_material.set_shader_parameter("mask_texture", mask_texture)
	material = shader_material

func _input(event):
	if mask_image == null:
		return
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var local_pos = get_global_mouse_position() - global_position
			if Rect2(Vector2.ZERO, size).has_point(local_pos):
				scratch_at_position(local_pos)

func scratch_at_position(pos: Vector2):
	var cx = int(pos.x)
	var cy = int(pos.y)
	var r = brush_size / 2.2

	for x in range(max(0, cx - r), min(mask_image.get_width(), cx + r + 1)):
		for y in range(max(0, cy - r), min(mask_image.get_height(), cy + r + 1)):
			if (x - cx) * (x - cx) + (y - cy) * (y - cy) <= r * r:
				mask_image.set_pixel(x, y, Color.WHITE)

	mask_texture.update(mask_image)
