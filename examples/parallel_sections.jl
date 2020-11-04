using OrthographicProjection
using FileManager
using Common
using Visualization

txtpotreedirs = "C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
all_files = FileManager.get_files_in_potree_folder(potreedirs[1],0)
PC = FileManager.las2pointcloud(all_files...)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
project_name = "Sezioni_Parallele"
output_folder = "C:/Users/marte/Documents/GEOWEB/TEST"
plane = Plane(1,0,0, 458300)
step = 30.0
thickness = 1.
@time planes = OrthographicProjection.get_parallel_sections(
	txtpotreedirs::String,
	project_name::String,
	output_folder::String,
	bbin::Union{AABB,String},
	step::Float64,
	plane::Plane,
	thickness::Float64)


GL.VIEW([
	GL.GLPoints(convert(Lar.Points,PC.coordinates')),
	[GL.GLGrid(planes[i][1],planes[i][2]) for i in 1:length(planes)]...
])
