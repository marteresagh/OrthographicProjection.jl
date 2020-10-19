"""
init
"""
function initParamsExtraction(txtpotreedirs::String,
							 outputfile::String,
							 coordsystemmatrix::Array{Float64,2},
							 bbin::Union{String,AABB},
							 quota::Union{Float64,Nothing},
							 thickness::Union{Float64,Nothing}
							 )
	# check validity
	@assert isfile(txtpotreedirs) "extractpointcloud: $txtpotreedirs not an existing file"

	if !isnothing(quota)
		@assert !isnothing(thickness) "extractpointcloud: thickness missing"
		q_l = quota - thickness/2
		q_u = quota + thickness/2
	else
		q_l = -Inf
		q_u = Inf
	end

	potreedirs = FileManager.get_directories(txtpotreedirs)
	model = getmodel(bbin)

	aabb = Common.boundingbox(model[1])
	mainHeader = FileManager.newHeader(aabb,"EXTRACTION",SIZE_DATARECORD)

	return ParametersExtraction(outputfile,
								potreedirs,
								coordsystemmatrix,
								model,
								q_l,
								q_u,
								mainHeader)
end
