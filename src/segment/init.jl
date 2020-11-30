"""
Initialize parameters for segment algorithm.
"""
function init(txtpotreedirs::String,
	outputfile::String,
	model::Lar.LAR
	)

	potreedirs = get_potree_dirs(txtpotreedirs)

	aabb = Common.boundingbox(model[1])
	mainHeader = FileManager.newHeader(aabb,"EXTRACTION",SIZE_DATARECORD)

	return ParametersExtraction(outputfile,
	potreedirs,
	model,
	mainHeader)
end
