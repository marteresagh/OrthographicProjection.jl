println("loading packages... ")

using ArgParse
using OrthographicProjection

println("packages OK")

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
		"--output", "-o"
            help = "Output file: LAS"
			required = true
        "source"
            help = "A text file with Potree directory list"
            required = true
		"--bbox"
			help = "Bounding box as 'x_min y_min z_min x_max y_max z_max'"
			arg_type = String
		"--jsonfile"
	    	help = "Path to Potree JSON volume model"
			arg_type = String
		"--c"
			help = "Position"
			arg_type = String
		"--e"
			help = "Scale"
			arg_type = String
		"--r"
			help = "Rotation"
			arg_type = String
    end

    return parse_args(s)
end

function main()
	args = parse_commandline()

	OrthographicProjection.flushprintln("== params ==")
	for (arg,val) in args
		OrthographicProjection.flushprintln("$arg  =>  $val")
	end

	bbox = args["bbox"]
	jsonfile = args["jsonfile"]
	position_ = args["position"]
	scale_ = args["scale"]
	rotation_ = args["rotation"]
	output = args["output"]
	txtpotreedirs = args["source"]

	model = nothing

	if !isnothing(bbox)
		b = tryparse.(Float64,split(bbox, " "))
		@assert length(b) == 6 "Required bounding box as 'x_min y_min z_min x_max y_max z_max'"
		bbox = OrthographicProjection.AABB(b[4],b[1],b[5],b[2],b[6],b[3])
		model = OrthographicProjection.getmodel(bbox)
	elseif !isnothing(jsonfile)
		model = OrthographicProjection.getmodel(bbox)
	else
		scale = tryparse.(Float64,split(scale_, " "))
		@assert length(scale) == 3 "a 3D vector needed"
		position = tryparse.(Float64,split(position_, " "))
		@assert length(position) == 3 "a 3D vector needed"
		rotation = tryparse.(Float64,split(rotation_, " "))
		@assert length(rotation) == 3 "a 3D vector needed"
		volume = OrthographicProjection.Volume(scale,position,rotation)
		model = OrthographicProjection.getmodel(volume)
	end

	OrthographicProjection.segment(txtpotreedirs, output, model)
end

@time main()
