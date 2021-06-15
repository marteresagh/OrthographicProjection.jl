println("loading packages... ")

using OrthographicProjection

println("packages OK")

function main()

	txtpotreedirs = raw"C:\Users\marte\Documents\potreeDirectory\pointclouds\CAVA"
	project_name = "TEST_SLICES"
	output_folder = "C:\Users\marte\Documents\Julia_package\package_test\TEST\SCRIPT_SLICING"
	bbin = "458117.68 4493768.53 196.68 458452.43 4494171.78 237.49"
	steps = nothing
	step = 5
	n = 10
	p1_ = "458145.180 4493834.030 224.250"
	p2_ = "458255.180 4493775.530 226.050"
	axis_ = "0 0 1"
	thickness = 1.0

	b = tryparse.(Float64,split(bbin, " "))
	if length(b) == 6
		bbin = OrthographicProjection.AABB(b[4],b[1],b[5],b[2],b[6],b[3])
	end

	p1 = tryparse.(Float64,split(p1_, " "))
	@assert length(p1) == 3 "a 3D point needed"
	p2 = tryparse.(Float64,split(p2_, " "))
	@assert length(p2) == 3 "a 3D point needed"
	axis_y = tryparse.(Float64,split(axis_, " "))
	@assert length(axis_y) == 3 "a 3D axis needed"

	if !isnothing(step) && !isnothing(n)
		steps = fill(step,n)
	elseif !isnothing(steps)
		steps = tryparse.(Float64,split(steps, " "))
	else
		steps = Float64[]
	end

	prepend!(steps,0.0)


	proj_folder, plane, model = OrthographicProjection.preprocess(project_name, output_folder, bbin, p1, p2, axis_y, thickness)
	OrthographicProjection.get_parallel_sections(txtpotreedirs, project_name, proj_folder, bbin, steps, plane, model)


end

@time main()
