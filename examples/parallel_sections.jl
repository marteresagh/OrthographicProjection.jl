using OrthographicProjection
using FileManager
using Common
using Visualization

get_parallel_sections(
	txtpotreedirs::String,
	project_name::String,
	output_folder::String,
	bbin::Union{AABB,String},
	step::Float64,
	plane::Plane,
	thickness::Float64)
