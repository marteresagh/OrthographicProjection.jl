println("loading packages... ")

using ArgParse
using OrthographicProjection

println("packages OK")

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
		"--output", "-o"
            help = "Output file: LAS format"
			required = true
        "source"
            help = "A text file with Potree directories list or a single Potree directory"
            required = true
		"--epsg"
			help = "EPSG code"
			arg_type = Int
		"--bbox"
			help = "Bounding box as 'x_min y_min z_min x_max y_max z_max'"
			arg_type = String
    end

    return parse_args(s)
end

function main()
	args = parse_commandline()

	OrthographicProjection.flushprintln("== params ==")
	for (arg,val) in args
		if !isnothing(val)
			OrthographicProjection.flushprintln("$arg  =>  $val")
		end
	end

	bbox = args["bbox"]
	epsg = args["epsg"]
	output = args["output"]
	txtpotreedirs = args["source"]

	b = tryparse.(Float64,split(bbox, " "))
	@assert length(b) == 6 "Required bounding box as 'x_min y_min z_min x_max y_max z_max'"
	bbox = OrthographicProjection.AABB(b[4],b[1],b[5],b[2],b[6],b[3])
	model = OrthographicProjection.getmodel(bbox)

	OrthographicProjection.segment(txtpotreedirs, output, model; epsg = epsg)
end

@time main()
