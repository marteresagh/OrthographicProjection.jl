function init_params(txtpotreedirs::String,
							 outputfile::String,
							 model
							 )
	# check validity
	@assert isfile(txtpotreedirs) "extractpointcloud: $txtpotreedirs not an existing file"
	potreedirs = FileManager.get_directories(txtpotreedirs)
	aabb = Common.boundingbox(model[1])
	mainHeader = FileManager.newHeader(aabb,"EXTRACTION",SIZE_DATARECORD)

	return ParametersExtraction(outputfile,
								potreedirs,
								Matrix{Float64}(Lar.I,3,3),
								model,
								mainHeader)
end



function extract_section(txtpotreedirs, output, model)
	params = init_params(txtpotreedirs, output, model)

	n = 0
	temp = joinpath(splitdir(params.outputfile)[1],"temp.las")
	open(temp, "w") do s
		write(s, LasIO.magic(LasIO.format"LAS"))
		n = process_trie(params,s,n) #extraction_core(params,s,n)
	end

	savepointcloud( params, n, temp)
end
