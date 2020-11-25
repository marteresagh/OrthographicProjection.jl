function init(txtpotreedirs::String,
	outputfile::String,
	model::Lar.LAR
	)

	if isfile(txtpotreedirs)
		potreedirs = FileManager.get_directories(txtpotreedirs)
	elseif isdir(txtpotreedirs)
		potreedirs = [txtpotreedirs]
	end

	aabb = Common.boundingbox(model[1])
	mainHeader = FileManager.newHeader(aabb,"EXTRACTION",SIZE_DATARECORD)

	return ParametersExtraction(outputfile,
	potreedirs,
	model,
	mainHeader)
end
