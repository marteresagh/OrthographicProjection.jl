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
            help = "A Potree directory"
            required = true
		"--epsg"
			help = "EPSG code"
			arg_type = Int
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

	epsg = args["epsg"]
	output = args["output"]
	txtpotreedirs = args["source"]

	potreedirs = OrthographicProjection.get_potree_dirs(txtpotreedirs)
	metadata = OrthographicProjection.CloudMetadata(potreedirs[1])
	bbin = metadata.tightBoundingBox
	model = OrthographicProjection.getmodel(bbin)

	OrthographicProjection.segment(txtpotreedirs, output, model; epsg = epsg)
end

@time main()
