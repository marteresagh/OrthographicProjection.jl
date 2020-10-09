"""
init
"""
function initParamsExtraction(txtpotreedirs::String,
							 outputfile::String,
							 coordsystemmatrix::Array{Float64,2},
							 bbin::Union{String,Tuple{Array{Float64,2},Array{Float64,2}}},
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

	potreedirs = PointClouds.getdirectories(txtpotreedirs)
	model = PointClouds.getmodel(bbin)
	aabb = Lar.boundingbox(model[1])
	mainHeader = newHeader(aabb,"EXTRACTION",SIZE_DATARECORD)

	# TODO salvataggio del BB del volume in formato json o ascii da rimettere
	return ParametersExtraction(outputfile,
								potreedirs,
								coordsystemmatrix,
								model,
								q_l,
								q_u,
								mainHeader)
end
