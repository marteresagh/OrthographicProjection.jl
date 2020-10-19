println("loading packages... ")

using ArgParse
using OrthographicProjection

println("packages OK")

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
		"--output", "-o"
            help = "Output file: LAS or LAZ"
			required = true
		"--bbin"
            help = "Bounding box as 'x_min y_min z_min x_max y_max z_max' or Potree JSON volume model"
			required = true
		"--quote"
			help = "Plane quote"
			arg_type = Float64
		"--thickness"
			help = "Plane thickness"
			arg_type = Float64
        "source"
            help = "A text file with Potree directory list"
            required = true
    end

    return parse_args(s)
end

function main()
    args = parse_commandline()

	PointClouds.flushprintln("== params ==")
    for (arg,val) in args
        	PointClouds.flushprintln("$arg  =>  $val")
    end

	bbin = args["bbin"]
	output = args["output"]
	txtpotreedirs = args["source"]
	q = args["quote"]
	thickness = args["thickness"]

	b = tryparse.(Float64,split(bbin, " "))
	if length(b) == 6
		#bbin = (hcat([b[1],b[2],b[3]]),hcat([b[4],b[5],b[6]]))
		bbin = OrthographicProjection.AABB(b[4],b[1],b[5],b[2],b[6],b[3])
	end

	if isnothing(ucs)
		ucs = Matrix{Float64}(OrthographicProjection.Lar.I,3,3)
	end

	OrthographicProjection.pointExtraction(txtpotreedirs, output, bbin, q, thickness)
end

@time main()
