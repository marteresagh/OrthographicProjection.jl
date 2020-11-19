function init(txtpotreedirs::String,
	outputfile::String,
	model::Lar.LAR
	)

	@assert isfile(txtpotreedirs) "extractpointcloud: $txtpotreedirs not an existing file" # check validity
	potreedirs = FileManager.get_directories(txtpotreedirs)
	aabb = Common.boundingbox(model[1])
	mainHeader = FileManager.newHeader(aabb,"EXTRACTION",SIZE_DATARECORD)

	return ParametersExtraction(outputfile,
	potreedirs,
	model,
	mainHeader)
end
