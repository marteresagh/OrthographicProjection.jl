"""
extract parallel sections
"""
function get_parallel_sections(
	txtpotreedirs::String,
	project_name::String,
	output_folder::String,
	bbin::Union{AABB,String},
	step::Float64,
	plane::Plane,
	thickness::Float64)


	planes = get_planes(plane, step, thickness, bbin)

	@assert isdir(folder) "$folder not an existing folder"
	proj_folder = joinpath(folder,project_name)

	if !isdir(proj_folder)
		mkdir(proj_folder)
	end

	for i in 1:length(planes)
		output = joinpath(proj_folder,project_name)*"section_$i.las"
		OrthographicProjection.pointExtraction(txtpotreedirs, output, planes[i], nothing, nothing)
	end
end

"""
Described all parallel plane for sections extraction
"""
function get_planes(plane::Plane, step::Float64, thickness::Float64, bbin::Union{AABB,String})
	model = getmodel(bbin)
	aabb = Common.boundingbox(model[1])

	quotas = get_quotas(plane, step, model)

	planes = []
	for quota in quotas
		plane = plane2model(Lar.inv(plane.matrix)[1:3,1:3], quota, thickness, aabb)
		push!(planes,plane)
	end

	return planes
end

"""
all quotas
"""
function get_quotas(plane::Plane, step::Float64, model::Lar.LAR)
	normal = [plane.a,plane.b,plane.c]
	V = model[1]
	dists = [Lar.dot(normal, V[:,i]) for i in 1:size(V,2)]
	min,max = extrema(dists)
	quota = min+modf((plane.d-min)/step)[1]*step
	quotas = Float64[]
	while quota <= max
		push!(quotas,quota)
		quota = quota+step
	end
	return quotas
end
