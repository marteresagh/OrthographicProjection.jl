
function orthophoto(
	txtpotreedirs::String,
	outputimage::String,
	bbin::Union{String,Tuple{Array{Float64,2},Array{Float64,2}}},
	GSD::Float64,
	PO::String,
	quota::Union{Float64,Nothing},
	thickness::Union{Float64,Nothing},
	ucs::Union{String,Nothing},
	pc::Bool
	)

	# initialization
	params = PointClouds.initparams( txtpotreedirs, outputimage, bbin, GSD,	PO,	quota,	thickness,	ucs, pc);


	# image creation
	PointClouds.flushprintln("========= PROCESSING =========")

	n = 0 #number of extracted points
	n, temp = PointClouds.orthophoto_core(params, n)

	PointClouds.flushprintln("========= SAVES =========")
	PointClouds.saveorthophoto(params)

	if pc
		PointClouds.savepointcloud( params, n, temp)
	end
end
