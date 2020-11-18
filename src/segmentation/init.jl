"""
init
"""
function initParamsExtraction(txtpotreedirs::String,
							 outputfile::String,
							 coordsystemmatrix::Array{Float64,2},
							 bbin::Union{String,AABB},
							 quota::Union{Float64,Nothing},
							 thickness::Union{Float64,Nothing},
							 #ucs
							 )
	# check validity
	@assert isfile(txtpotreedirs) "extractpointcloud: $txtpotreedirs not an existing file"


	potreedirs = FileManager.get_directories(txtpotreedirs)
	model = getmodel(bbin)
	aabb = Common.boundingbox(model[1])

	if !isnothing(quota) && !isnothing(thickness)
		model = Common.plane2model(coordsystemmatrix, quota, thickness, aabb)
	end


	mainHeader = FileManager.newHeader(aabb,"EXTRACTION",SIZE_DATARECORD)

	return ParametersExtraction(outputfile,
								potreedirs,
								coordsystemmatrix,
								model,
								mainHeader)
end
