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
		"--bbin"
            help = "Bounding box as 'x_min y_min z_min x_max y_max z_max' or Potree JSON volume model"
			required = true
        "source"
            help = "A text file with Potree directory list"
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

	bbin = args["bbin"]
	output = args["output"]
	txtpotreedirs = args["source"]

	b = tryparse.(Float64,split(bbin, " "))
	if length(b) == 6
		bbin = OrthographicProjection.AABB(b[4],b[1],b[5],b[2],b[6],b[3])
	end
	model = OrthographicProjection.getmodel(bbin)

	OrthographicProjection.extract_section(txtpotreedirs, output, model)
end

@time main()
