extends RayCast

class_name Surfacer

var current_colliding_surface : MeshInstance #Superficie actual de colision
var surface_sound_type : String  #Material en el que pisas

onready var geo = Geometry
onready var body = get_parent() #el jugador

var mdt_array = [] #Mesh data tool

func _physics_process(delta: float) -> void:
	if is_colliding() and body.is_moving():
		var col = get_collider()
		#Si colisiona con una mesh instance
		if current_colliding_surface != col.get_parent() and col.get_parent() is MeshInstance:
			#Colisionas con un static body siempre en el piso, y su padre es un mesh instance
			current_colliding_surface = col.get_parent()
			# Si el mesh tiene solo 1 superficie se obtiene el primero y listo PERO SI NO se llama otro metodo
			if current_colliding_surface.mesh.get_surface_count() == 1: #si solo es un spatial material
				#print("El piso tiene materiales: "+ str(current_colliding_surface.get_surface_material_count() ))
				#print(current_colliding_surface.get_active_material(0)) Al metodo se le pasa este material
				#print(current_colliding_surface.get_active_material(0).albedo_texture.load_path)
				#analyse_mat_path(current_colliding_surface.get_active_material(0)) Con esto analiza el material
				#analyse_mat_path(current_colliding_surface.get_active_material(0).albedo_texture.load_path)
				print("El terreno pisado tiene el material: "+current_colliding_surface.get_active_material(0).resource_path)
				analyse_mat_path(current_colliding_surface.get_active_material(0))
				mdt_array.clear()
				return
			else:
				print(current_colliding_surface.get_active_material(0).resource_path)
				build_mesh_mdts() #Mesh data tool, cuando hay más de un material spatial
		extract_surface_sound_type(get_collision_point())

func build_mesh_mdts():
	mdt_array.clear()
	var mesh = current_colliding_surface.mesh
	for s in mesh.get_surface_count():
		var mdt = MeshDataTool.new() #Ayuda a hacer tareas matematicas con los mesh
		mdt.create_from_surface(mesh,s) #Crea una virtual mesh desde el material que le dimos normal, uv, vertices etc
		mdt_array.append(mdt)
		
var last_mdt : MeshDataTool = null

func extract_surface_sound_type(point):
	for mdt in  mdt_array: #Si el array tiene elementos
		if last_mdt == mdt:
			continue
		for v in range(mdt.get_vertex_count()): #Por cada vertice
			var faces = mdt.get_vertex_faces(v) #Vertices de cada face, cara del modelado en blender
			for f in faces:
				if mdt.get_face_normal(f).dot(Vector3.UP) < 0.1: #Para que no haya caras que ven hacia abajo por ejemplo, si caminas en el techo tal vez no quieras esta linea
					continue
				#Regresa los vertices de las caras
				var tri = [mdt.get_vertex(mdt.get_face_vertex(f,0)),
				mdt.get_vertex(mdt.get_face_vertex(f,1)),
				mdt.get_vertex(mdt.get_face_vertex(f,2)),]
				
				#Donde estamos pisando en el mesh, el origen del raycast
				#Nuestra posicion a las direcciones a donde esta apuntando el raycast
				#Se construye el triangulo para checar si esta atravesandolo
				#Se convierte cada uno de los vertices en coordenadas globales si no no funcionaria
				#Si es verdadero y estamos dentro del triangulo se utiliza los sonidos que hara
				if geo.ray_intersects_triangle(
					global_transform.origin,
					global_transform.origin.direction_to(point),
					current_colliding_surface.to_global(tri[0]),
					current_colliding_surface.to_global(tri[1]),
					current_colliding_surface.to_global(tri[2])):

					last_mdt = mdt #Para no checarlo doble vez si ya estas en el mismo
					
					print(mdt.get_material().resource_path) #Checar que este string que se pasa al metodo analizar mat path contenga "dirt, "stone" etc
					analyse_mat_path(mdt.get_material())
					return
					#Asegurate que el mesh no tenga demasiadas subdivisiones o tu pc explota

"""
Convierte el resource path en string y busca palabras en el material para clasificarlos en sonidos
"""
func analyse_mat_path(material):
	var math_path : String = str(material.resource_path)
	#print(math_path)
	if "grass" in math_path:
		surface_sound_type = "GRASS"
	elif "rock" in math_path or "stone" in math_path:
		surface_sound_type = "STONE"
	elif "metal" in math_path:
		surface_sound_type = "METAL"
	elif "tile" in math_path:
		surface_sound_type = "TILE"
	elif "fabric" in math_path:
		surface_sound_type = "FABRIC"
	else:
		surface_sound_type = "NULL"
	body.set_footstep_profile(surface_sound_type)

"""
Por si alguno requiere saber en que tipo de material estas pisando
"""
func get_surface_sound_type():
	return surface_sound_type





