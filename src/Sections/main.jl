"""
Preprocessing of data.
"""
function preprocess(
	project_name::String,
	output_folder::String,
	bbin::Union{AABB,String},
	plane::Plane,
	thickness::Float64
	)

	proj_folder = FileManager.mkdir_project(output_folder, project_name)
	model = Common.plane2model(plane, thickness, bbin)

	return proj_folder,model
end

function preprocess(
	project_name::String,
	output_folder::String,
	bbin::Union{AABB,String},
	p1::Array{Float64,1},
	p2::Array{Float64,1},
	axis_y::Array{Float64,1},
	thickness::Float64
	)

	proj_folder = FileManager.mkdir_project(output_folder, project_name)

	try
		plane = OrthographicProjection.Plane(p1,p2,axis_y)
		model = Common.plane2model(p1,p2,axis_y,thickness,bbin)
		return proj_folder,plane,model
	catch y
		flushprintln("ERROR: Plane not consistent")
		io = open(joinpath(proj_folder,"process.prob"),"w")
		close(io)
		throw(DomainError())
	end
end


function get_parallel_sections(
	txtpotreedirs::String,
	project_name::String,
	proj_folder::String,
	bbin::Union{AABB,String},
	step::Float64,
	plane::Plane,
	model::Lar.LAR,
	thickness::Float64)


	V,EV,FV = model

	quotas, indices = get_quotas(plane, step, bbin)

	planes = Lar.LAR[]
	n_sections = length(quotas)
	for i in 1:length(indices)
		flushprintln(" ")
		flushprintln(" ---- Section $i of $n_sections ----")
		T = Common.apply_matrix(Lar.t(plane.matrix[1:3,3]*indices[i]*step...),V)
		plan = (T,EV,FV)
		push!(planes,plan)
		output = joinpath(proj_folder,project_name)*"_section_$(indices[i]).las"
		extract_section(txtpotreedirs, output, plan)
	end

	return planes
end


function get_quotas(plane::Plane, step::Float64,  bbin::Union{AABB,String})

	model = getmodel(bbin)
	normal = [plane.a,plane.b,plane.c]
	V = model[1]
	dists = [Lar.dot(normal, V[:,i]) for i in 1:size(V,2)]
	min,max = extrema(dists)
	quota = min+modf((plane.d-min)/step)[1]*step
	quotas = Float64[]

	if step > 0
		while quota <= max
			push!(quotas,quota)
			quota = quota+step
		end
		ind_0 = findall(x->x==plane.d,quotas)[1]

		return quotas, [-(ind_0-1):(length(quotas)-ind_0)...]
	elseif step == 0
		return plane.d, [0]
	else
		while quota <= max
			push!(quotas,quota)
			quota = quota+(-step)
		end
		ind_0 = findall(x->x==plane.d,quotas)[1]

		return quotas, [-(length(quotas)-ind_0):(ind_0-1)...]
	end

end
