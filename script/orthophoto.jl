println("loading packages... ")

using ArgParse
using OrthographicProjection

println("packages OK")

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
		"--output", "-o"
            help = "Output image"
			required = true
		"--bbin"
            help = "Bounding box as 'x_min y_min z_min x_max y_max z_max' or Potree JSON volume model"
			required = true
		"--po"
            help = "Orthographic projection: XY+, XY-, XZ+, XZ-, YZ+, YZ-"
			arg_type = String
            default = "XY+"
        "--gsd"
            help = "Resolution"
            arg_type = Float64
            default = 0.3
		"--quote"
			help = ".."
			arg_type = Float64
		"--thickness"
			help = ".."
			arg_type = Float64
		"--pc"
			help = "If true a pc of extracted model is saved in a LAS file"
			action = :store_true
		"--ucs"
			help = "Path to UCS JSON file. If not provided is the Identity matrix."
			arg_type = String
		"--bgcolor"
			help = "Background color"
			arg_type = String
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
	outputimage = args["output"]
	PO = args["po"]
	GSD = args["gsd"]
	txtpotreedirs = args["source"]
	q = args["quote"]
	thickness = args["thickness"]
	pc = args["pc"]
	ucs = args["ucs"]
	bgcolor = args["bgcolor"]

	b = tryparse.(Float64,split(bbin, " "))
	if length(b) == 6
		#bbin = (hcat([b[1],b[2],b[3]]),hcat([b[4],b[5],b[6]]))
		bbin = OrthographicProjection.AABB(b[4],b[1],b[5],b[2],b[6],b[3])
	end

	if isnothing(ucs)
		ucs = Matrix{Float64}(OrthographicProjection.Lar.I,3,3)
	end

	if !isnothing(bgcolor)
		col = tryparse.(Float64,split(bgcolor, " "))
		background = [col[1],col[2],col[3]]
	else
		background = [1.0,1.0,1.0]
	end

	OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, q, thickness, ucs, background, pc)
end

@time main()
