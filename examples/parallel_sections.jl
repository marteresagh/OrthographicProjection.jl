using OrthographicProjection
using FileManager
using Common

txtpotreedirs = "C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
project_name = "Sezioni_Parallele"
output_folder = "C:/Users/marte/Documents/GEOWEB/TEST"
plane = Plane(1,0,0, 458300)
step = 66.0
thickness = 0.3
@time OrthographicProjection.get_parallel_sections(
	txtpotreedirs::String,
	project_name::String,
	output_folder::String,
	bbin::Union{AABB,String},
	step::Float64,
	plane::Plane,
	thickness::Float64)
