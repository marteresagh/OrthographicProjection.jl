using FileManager
using Visualization
using Common
using OrthographicProjection


source = "C:/Users/marte/Documents/potreeDirectory/pointclouds/CASALETTO"
bbin = "291245.24099949156 4630321.9456008379 103.747100725544 291270.88120483406 4630353.589802093 113.38310279812"

b = tryparse.(Float64,split(bbin, " "))
if length(b) == 6
	#bbin = (hcat([b[1],b[2],b[3]]),hcat([b[4],b[5],b[6]]))
	bbin = OrthographicProjection.AABB(b[4],b[1],b[5],b[2],b[6],b[3])
end


PC = FileManager.source2pc(source,0)

##################
# ucs definition #
##################
origin = [291268.197, 4630327.588, 104.254]
punto_x = [291267.968, 4630328.033, 104.251]

axis_x = (punto_x-origin)/Lar.norm(punto_x-origin)
# axis_x = rand(3)
# axis_x /= Lar.norm(axis_x)
axis_z = [0,0,1.]

function orthonormal_basis(axis_x, axis_z)
	axis_y = Lar.cross(axis_z,axis_x)
	axis_y /= Lar.norm(axis_y)
	return Common.orthonormal_basis(origin,punto_x,axis_y)
end

ucs = orthonormal_basis(axis_x, axis_z)
# ucs = Matrix{Float64}(Lar.I,3,3)
rot = Common.matrix4(ucs)

UCS0 = copy(rot)
UCS0[1:3,4] = origin

UCS = Lar.inv(UCS0)

PO = "XY+" #"XZ+", "YZ+", "XY+"
q =  2.0 #291268.197, 4630327.588,  104.254
thickness = 1.0
coordsystemmatrix = OrthographicProjection.PO2matrix(PO,UCS)
model = OrthographicProjection.Common.getmodel(bbin)
aabb = OrthographicProjection.Common.boundingbox(model[1])

origine = Lar.inv(UCS)[1:3,4]

model = getmodel(Lar.inv(coordsystemmatrix), q, thickness, aabb; new_origin = origine)
mod_aabb = getmodel(aabb)
GL.VIEW([
	Visualization.points_color_from_rgb(Common.apply_matrix(Lar.t(-origin...),PC.coordinates),PC.rgbs),
	Visualization.helper_axis(Common.matrix4(Lar.inv(coordsystemmatrix)))...,
	GL.GLGrid(Common.apply_matrix(Lar.t(-origin...),model[1]),model[2]),
	GL.GLGrid(Common.apply_matrix(Lar.t(-origin...),mod_aabb[1]),mod_aabb[2])
])
