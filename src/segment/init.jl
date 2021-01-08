"""
Initialize parameters for segment algorithm.
"""
function init(txtpotreedirs::String,
	outputfile::String,
	model::Lar.LAR;
	epsg = nothing::Union{Nothing,Integer}
	)

	potreedirs = get_potree_dirs(txtpotreedirs)

	aabb = Common.boundingbox(model[1])

	mainHeader = FileManager.newHeader(aabb,"EXTRACTION",SIZE_DATARECORD)
	if !isnothing(epsg)
		FileManager.epsg_code!(mainHeader, epsg)
	end

	return ParametersExtraction(outputfile,
	potreedirs,
	model,
	mainHeader)
end
