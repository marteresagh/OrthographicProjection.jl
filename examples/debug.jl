using FileManager
using Visualization
using Common
using OrthographicProjection

source = "C:/Users/marte/Documents/potreeDirectory/pointclouds/CASALETTO"
PC = FileManager.source2pc(source,0)

############
# ucs test #
############
origin = [291268.197, 4630327.588, 104.254]
punto_x = [291267.968, 4630328.033, 104.251]

axis_x = (punto_x-origin)/Lar.norm(punto_x-origin)
axis_z = [0,0,1.]

function orthonormal_basis(axis_x, axis_z)
	axis_y = Lar.cross(axis_z,axis_x)
	axis_y /= Lar.norm(axis_y)
	return Common.orthonormal_basis(origin,punto_x,axis_y)
end


ucs = orthonormal_basis(axis_x, axis_z)
rot = Common.matrix4(ucs)

GL.VIEW([
	Visualization.points_color_from_rgb(Common.apply_matrix(Lar.t(-origin...),PC.coordinates),PC.rgbs)
	Visualization.helper_axis(rot)
])


UCS0 = copy(rot)
UCS0[1:3,4] = origin

UCS = Lar.inv(UCS0)
GL.VIEW([
	Visualization.points_color_from_rgb(Common.apply_matrix(UCS,PC.coordinates),PC.rgbs)
	Visualization.helper_axis()
])
######################################################
######################### FINE #######################
######################################################



bbin = "291245.24099949156 4630321.9456008379 103.747100725544 291270.88120483406 4630353.589802093 113.38310279812"
output = "C:/Users/marte/Documents/GEOWEB/TEST/SEGMENT/CASALETTO_UCS_TEST001.las"
PO = "YZ+"
txtpotreedirs = "C:/Users/marte/Documents/potreeDirectory/pointclouds/CASALETTO"
q = 0.0 #291268.197
thickness = 1.0
ucs0 = "C:/Users/marte/Documents/GEOWEB/wrapper_file/JSON/ucs_CASALETTO.json"
epsg = nothing

b = tryparse.(Float64,split(bbin, " "))
if length(b) == 6
	#bbin = (hcat([b[1],b[2],b[3]]),hcat([b[4],b[5],b[6]]))
	bbin = OrthographicProjection.AABB(b[4],b[1],b[5],b[2],b[6],b[3])
end

############################ UCS CON NUOVA VISTA #########################################
# ucs = FileManager.ucs2matrix(ucs0)
coordsystemmatrix = OrthographicProjection.PO2matrix(PO,UCS)
UCS_modificato = copy(Lar.inv(UCS))
UCS_modificato[1:3,1:3] = Lar.inv(coordsystemmatrix)
UCS_modificato = Lar.inv(UCS_modificato)

GL.VIEW([
	Visualization.points_color_from_rgb(Common.apply_matrix(UCS_modificato,PC.coordinates),PC.rgbs)
	Visualization.helper_axis()
])

############################ FINE #########################################

model = OrthographicProjection.Common.getmodel(bbin)
aabb = OrthographicProjection.Common.boundingbox(model[1])

origine = Lar.inv(UCS)[1:3,4]

function new_getmodel(basis::Matrix, origine, constant::Float64, thickness::Float64, aabb::AABB)::Lar.LAR
	#@show basis[:,3]
	verts,_ = getmodel(aabb)
	center_model = [(aabb.x_max+aabb.x_min)/2,(aabb.y_max+aabb.y_min)/2,(aabb.z_max+aabb.z_min)/2]
	#@show center_model
	quota = basis[:,3]*constant
	#@show Lar.dot(basis[:,3],center_model-origine)
	#position = center_model - Lar.dot(basis[:,3],center_model-origine)*basis[:,3]
	position =  center_model+(quota-Lar.dot(basis[:,3],center_model-origine)*basis[:,3])
	newverts = basis'*verts
	#extrema of newverts x e y
	x_range = extrema(newverts[1,:])
	y_range = extrema(newverts[2,:])


	scale = [x_range[2]-x_range[1]+1.e-2,y_range[2]-y_range[1]+1.e-2,thickness]
	volume = Volume(scale,position,Common.matrix2euler(basis))
	return Common.getmodel(volume)
end

model = new_getmodel(Lar.inv(coordsystemmatrix),origine,  10.0, thickness, aabb)
GL.VIEW([
	Visualization.points_color_from_rgb(Common.apply_matrix(Lar.t(-origin...),PC.coordinates),PC.rgbs),
	Visualization.helper_axis(Common.matrix4(Lar.inv(coordsystemmatrix)))...,
	GL.GLGrid(Common.apply_matrix(Lar.t(-origin...),model[1]),model[2])
])
