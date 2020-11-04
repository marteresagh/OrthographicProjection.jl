function init_params(txtpotreedirs::String,
							 outputfile::String,
							 bbin
							 )
	# check validity
	@assert isfile(txtpotreedirs) "extractpointcloud: $txtpotreedirs not an existing file"
	potreedirs = FileManager.get_directories(txtpotreedirs)
	mainHeader = FileManager.newHeader(aabb,"EXTRACTION",SIZE_DATARECORD)

	return ParametersExtraction(outputfile,
								potreedirs,
								Matrix{Float64}(Lar.I,3,3),
								bbin,
								-Inf,
								Inf,
								mainHeader)
end



function extract_section(txtpotreedirs, output, bbin)
	params = init_params(txtpotreedirs, output, bbin)

	n = 0
	temp = joinpath(splitdir(params.outputfile)[1],"temp.las")
	open(temp, "w") do s
		write(s, LasIO.magic(LasIO.format"LAS"))
		n = extraction_core(params,s,n)
	end

	savepointcloud( params, n, temp)
end
