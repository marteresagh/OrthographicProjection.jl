using OrthographicProjection
using FileManager
using Common
using Visualization

txtpotreedirs = "C:/Users/marte/Documents/potreeDirectory/pointclouds/MONTE_VETTORE" #"C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt"
potreedirs = OrthographicProjection.get_potree_dirs(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
#bbin = "C://Users//marte//Documents//GEOWEB//FilePotree//orthoCAVA//volume.json"
ucs = Matrix{Float64}(Lar.I,3,3)
GSD = 0.3
PO = "XZ+"
quota = (bbin.y_max+bbin.y_min)/2 #458277.430, 4493982.030, 210.840
thickness = 2000.
outputimage = "C:/Users/marte/Documents/GEOWEB/TEST/ORTHO/MONTEVERDE_AABB.jpg"
pc = true
background = [0.0,0.0,0.0]
@time OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, background, pc)


# DEBUG il problema è quando model è un piano che nell'approssimazione mi mangia dei valori.
params = OrthographicProjection.init( txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, background, pc);

modelsdetection(params.model, metadata.tightBoundingBox)

# all_files = FileManager.get_files_in_potree_folder(potreedirs[1],0, true)
# PC = FileManager.las2pointcloud(all_files...)

function plane2model(rot_mat::Matrix, constant::Float64, thickness::Float64, aabb::AABB)::Lar.LAR
	verts,_ = getmodel(aabb)
	rotation = Common.matrix2euler(rot_mat)
	center_model = [(aabb.x_max+aabb.x_min)/2,(aabb.y_max+aabb.y_min)/2,(aabb.z_max+aabb.z_min)/2]
	quota = rot_mat[:,3]*constant
	position = center_model+(quota-Lar.dot(rot_mat[:,3],center_model)*rot_mat[:,3])
	newverts = rot_mat'*verts
	x_range = extrema(newverts[1,:])
	y_range = extrema(newverts[2,:])
	@show x_range
	@show y_range

	#extrema of newverts x e y
	scale = [x_range[2]-x_range[1]+1.e-2,y_range[2]-y_range[1]+1.e-2,thickness]
	volume = Volume(scale,position,rotation)
	@show volume.scale
	@show volume.position
	@show volume.rotation
	model = Common.volume2LARmodel(volume)
	return model
end

coordsystemmatrix = OrthographicProjection.PO2matrix(PO)
model = plane2model(Lar.convert(Matrix,coordsystemmatrix'), quota, thickness, bbin)

V,EV,FV = model

Common.modelsdetection(model, metadata.tightBoundingBox)
# point cloud
T = Common.apply_matrix(Lar.t(-V[:,1]...),V)
GL.VIEW(
    [
    GL.GLGrid(T,EV),
	#GL.GLGrid(V2,EV2),
	GL.GLPoints(convert(Lar.Points,T[:,5]'),GL.COLORS[12]),
	GL.GLPoints(convert(Lar.Points,T[:,1]'),GL.COLORS[2]),
	GL.GLPoints(convert(Lar.Points,T[:,6]'),GL.COLORS[3]),
	GL.GLPoints(convert(Lar.Points,T[:,7]'),GL.COLORS[4]),
	GL.GLFrame
	#Visualization.points_color_from_rgb(PC.coordinates,PC.rgbs)
    ]
)

all_files = FileManager.get_files_in_potree_folder(potreedirs[1],20)
PC = FileManager.las2pointcloud(all_files...)
