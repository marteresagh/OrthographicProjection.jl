
function orthophoto(
	txtpotreedirs::String,
	outputimage::String,
	bbin::Union{String,AABB},
	GSD::Float64,
	PO::String,
	quota::Union{Float64,Nothing},
	thickness::Union{Float64,Nothing},
	ucs::Union{String,Matrix{Float64}},
	BGcolor::Array{Float64,1},
	pc::Bool
	)

	# initialization
	params = initparams( txtpotreedirs, outputimage, bbin, GSD,	PO,	quota,	thickness,	ucs, BGcolor, pc);


	# image creation
	flushprintln("========= PROCESSING =========")

	n = 0 #number of extracted points
	n, temp = orthophoto_core(params, n)

	flushprintln("========= SAVES =========")
	saveorthophoto(params)

	if pc
		savepointcloud( params, n, temp)
	end
end
