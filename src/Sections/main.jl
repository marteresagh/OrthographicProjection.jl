# """
# extract parallel sections
# """
# function get_parallel_sections(
# 	txtpotreedirs::String,
# 	project_name::String,
# 	output_folder::String,
# 	bbin::Union{AABB,String},
# 	step::Float64,
# 	plane::Plane,
# 	thickness::Float64)
#
#
# 	planes = get_planes(plane, step, thickness, bbin)
# 	@assert isdir(output_folder) "$output_folder not an existing folder"
# 	proj_folder = joinpath(output_folder,project_name)
#
# 	if !isdir(proj_folder)
# 		mkdir(proj_folder)
# 	end
#
# 	n_sections = length(planes)
# 	for i in 1:n_sections
# 		flushprintln(" ")
# 		flushprintln(" ---- Section $i of $n_sections ----")
# 		output = joinpath(proj_folder,project_name)*"section_$i.las"
# 		extract_section(txtpotreedirs, output, planes[i])
# 	end
# end
#
# """
# Described all parallel plane for sections extraction
# """
# function get_planes(plane::Plane, step::Float64, thickness::Float64, bbin::Union{AABB,String})
# 	model = getmodel(bbin)
# 	aabb = Common.boundingbox(model[1])
#
# 	quotas = get_quotas(plane, step, model)
#
# 	planes = Lar.LAR[]
# 	for quota in quotas
# 		plan = Common.plane2model(plane.matrix[1:3,1:3], quota, thickness, aabb)
# 		push!(planes,plan)
# 	end
#
# 	return planes
# end
#
# """
# all quotas
# """
# function get_quotas(plane::Plane, step::Float64, model::Lar.LAR)
# 	normal = [plane.a,plane.b,plane.c]
# 	V = model[1]
# 	dists = [Lar.dot(normal, V[:,i]) for i in 1:size(V,2)]
# 	min,max = extrema(dists)
# 	quota = min+modf((plane.d-min)/step)[1]*step
# 	quotas = Float64[]
# 	while quota <= max
# 		push!(quotas,quota)
# 		quota = quota+step
# 	end
# 	return quotas
# end


##### NEW VERSION
function get_parallel_sections(
	txtpotreedirs::String,
	project_name::String,
	output_folder::String,
	bbin::Union{AABB,String},
	step::Float64,
	plane::Plane,
	model::Lar.LAR,
	thickness::Float64)


	planes = get_planes(plane, step, thickness, bbin)
	@assert isdir(output_folder) "$output_folder not an existing folder"
	proj_folder = joinpath(output_folder,project_name)

	if !isdir(proj_folder)
		mkdir(proj_folder)
	end

	n_sections = length(planes)
	for i in 1:n_sections
		flushprintln(" ")
		flushprintln(" ---- Section $i of $n_sections ----")
		output = joinpath(proj_folder,project_name)*"section_$i.las"
		extract_section(txtpotreedirs, output, planes[i])
	end
end

"""
Described all parallel plane for sections extraction
"""
function get_planes(plane::Plane, model::Lar.LAR, step::Float64, bbin::Union{AABB,String})
	V,EV,FV = model

	roto_trasl, quotas = get_quotas(plane, step, bbin)

	planes = Lar.LAR[]
	for quota in quotas
		T = Common.apply_matrix(Lar.inv(roto_trasl)*Lar.t(0,0,quota)*roto_trasl,V)
		plan = (T,EV,FV)
		push!(planes,plan)
	end

	return planes
end

"""
all quotas
"""
function get_quotas(plane::Lar.LAR, step::Float64,  bbin::Union{AABB,String})

	model = getmodel(bbin)
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

	return Common.matrix4(Lar.inv(plane.matrix)), quotas
end
