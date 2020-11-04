println("loading packages... ")

using ArgParse
using OrthographicProjection

println("packages OK")

function parse_commandline()
	s = ArgParseSettings()

	@add_arg_table! s begin
	"source"
		help = "A text file with Potree directory list"
		arg_type = String
		required = true
	"--projectname", "-p"
		help = "Project name"
		arg_type = String
		required = true
	"--output", "-o"
		help = "Output folder"
		arg_type = String
		required = true
	"--bbin"
        help = "Bounding box as 'x_min y_min z_min x_max y_max z_max' or Potree JSON volume model"
		required = true
	"--step"
		help = "Distance between sections"
		arg_type = Float64
		required = true
	"--plane"
		help = "a, b, c, d parameters described the plane"
		arg_type = String
		required = true
	"--thickness"
		help = "Sections thickness"
		arg_type = Float64
		required = true
	end

	return parse_args(s)
end

function main()
	args = parse_commandline()

	OrthographicProjection.flushprintln("== params ==")
	for (arg,val) in args
		OrthographicProjection.flushprintln("$arg  =>  $val")
	end

	txtpotreedirs = args["source"]
	project_name = args["projectname"]
	output_folder = args["output"]
	bbin = args["bbin"]
	step = args["step"]
	plane = args["plane"]
	thickness = args["thickness"]
	b = tryparse.(Float64,split(bbin, " "))
	if length(b) == 6
		#bbin = (hcat([b[1],b[2],b[3]]),hcat([b[4],b[5],b[6]]))
		bbin = OrthographicProjection.AABB(b[4],b[1],b[5],b[2],b[6],b[3])
	end

	OrthographicProjection.get_parallel_sections(txtpotreedirs, project_name, output_folder, bbin, step, plane, thickness)
end

@time main()
