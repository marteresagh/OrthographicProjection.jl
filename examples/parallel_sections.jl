using OrthographicProjection
using FileManager
using Common
using Visualization

txtpotreedirs = "C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
all_files = FileManager.get_files_in_potree_folder(potreedirs[1],0)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
aabb = getmodel(bbin)
project_name = "Sezioni_parallele"
output_folder = "C:/Users/marte/Documents/GEOWEB/TEST"
step = 30.
thickness = 10.
axis_y = [0.,0.,1]
p1 = [458145.180, 4493834.030, 224.250]
p2 = [458255.180, 4493775.530, 226.050]
p1 = [0,0,0.]
p2 = [0,0,2.]
plane = Plane(p1,p2,axis_y)
@time model = Common.plane2model(p1,p2,axis_y,thickness,bbin)

proj_folder, plane, model = OrthographicProjection.preprocess(
	project_name::String,
	output_folder::String,
	bbin::Union{AABB,String},
	p1::Array{Float64,1},
	p2::Array{Float64,1},
	axis_y::Array{Float64,1},
	thickness::Float64
	)

@time planes = OrthographicProjection.get_parallel_sections(
		txtpotreedirs::String,
		project_name::String,
		proj_folder::String,
		bbin::Union{AABB,String},
		step::Float64,
		plane::Plane,
		model::Lar.LAR,
		thickness::Float64)

# PC = FileManager.las2pointcloud(all_files...)
#
#
# GL.VIEW([
# 	GL.GLPoints(convert(Lar.Points,PC.coordinates')),
# 	#GL.GLGrid(model[1],model[2]),
# 	#GL.GLFrame,
# 	 GL.GLGrid(aabb[1],aabb[2]),
# 	#Visualization.helper_axis(Lar.t(Common.centroid(model[1])...)*Common.matrix4(plane.matrix[1:3,1:3]))...,
# 	[GL.GLGrid(planes[i][1],planes[i][2]) for i in 1:length(planes)]...
# ])


# julia parallel_sections.jl "C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt" --bbin "458117.68 4.49376853e6 196.68 458452.43 4.49417178e6 237.49" -o "C:/Users/marte/Documents/GEOWEB/TEST" -p "Sezioni_Parallele" --step 30 --plane "1 0 0 458300" --thickness 1
