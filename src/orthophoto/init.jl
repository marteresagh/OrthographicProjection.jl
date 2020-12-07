"""
Initialize parameters for orthographic projection algorithm.
"""
function init(
	txtpotreedirs::String,
	outputimage::String,
	bbin::Union{String,AABB},
	GSD::Float64,
	PO::String,
	quota::Union{Float64,Nothing},
	thickness::Union{Float64,Nothing},
	ucs::Union{String,Matrix{Float64}},
	BGcolor::Array{Float64,1},
	pc::Bool
	)

	# check validity
	@assert length(PO)==3 "orthoprojectionimage: $PO not valid view"


	outputfile = splitext(outputimage)[1]*".las"

	potreedirs = get_potree_dirs(txtpotreedirs)

	if typeof(ucs) == Matrix{Float64}
		coordsystemmatrix = PO2matrix(PO,ucs)
	else
		ucs = FileManager.ucs2matrix(ucs)
		coordsystemmatrix = PO2matrix(PO,ucs)
	end

	model = getmodel(bbin)
	aabb = Common.boundingbox(model[1])

	if !isnothing(quota) && !isnothing(thickness)
		directionview = PO[3]
	    if directionview == '-'
			quota = -quota
		end
		model = Common.plane2model(Lar.convert(Matrix,coordsystemmatrix'), quota, thickness, aabb)
	end

	aabb = Common.boundingbox(model[1])

	RGBtensor, rasterquote, refX, refY = init_raster_array(coordsystemmatrix, GSD, model, BGcolor)

	mainHeader = FileManager.newHeader(aabb,"ORTHOPHOTO",SIZE_DATARECORD)

	return  ParametersOrthophoto(PO,
					 outputimage,
					 outputfile,
					 potreedirs,
					 model,
					 coordsystemmatrix,
					 RGBtensor,
					 rasterquote,
					 GSD,
					 refX,
					 refY,
					 pc,
					 ucs,
					 mainHeader)
end
