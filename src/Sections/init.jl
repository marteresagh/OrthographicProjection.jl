function init(txtpotreedirs::String,
	outputfile::String,
	model::Lar.LAR
	)
	# check validity
	@assert isfile(txtpotreedirs) "extractpointcloud: $txtpotreedirs not an existing file"
	potreedirs = FileManager.get_directories(txtpotreedirs)
	aabb = Common.boundingbox(model[1])
	mainHeader = FileManager.newHeader(aabb,"EXTRACTION",SIZE_DATARECORD)

	return ParametersExtraction(outputfile,
	potreedirs,
	model,
	mainHeader)
end


function extract_section(txtpotreedirs, output, model)
	params = init(txtpotreedirs, output, model)
	n = nothing
	temp = joinpath(splitdir(params.outputfile)[1],"temp.las")
	open(temp, "w") do s
		write(s, LasIO.magic(LasIO.format"LAS"))
		n = process_trie(params,s)
	end

	savepointcloud(params, n, temp)
end
