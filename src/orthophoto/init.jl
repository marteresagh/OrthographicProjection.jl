"""
Basis.
"""
function string2matrix(PO::String,UCS=Matrix{Float64}(Lar.I,4,4)::Matrix)
    planecode = PO[1:2]
    @assert planecode == "XY" || planecode == "XZ" || planecode == "YZ" "orthoprojectionimage: $PO not valid view "

    directionview = PO[3]
    @assert directionview == '+' || directionview == '-' "orthoprojectionimage: $PO not valid view "

    coordsystemmatrix = Matrix{Float64}(Lar.I,3,3)

    # if planecode == XY # top, - bottom
    #     continue
    if planecode == "XZ" # back, - front
        coordsystemmatrix[1,1] = -1.
        coordsystemmatrix[2,2] = 0.
        coordsystemmatrix[3,3] = 0.
        coordsystemmatrix[2,3] = 1.
        coordsystemmatrix[3,2] = 1.
    elseif planecode == "YZ" # right, - left
        coordsystemmatrix[1,1] = 0.
        coordsystemmatrix[2,2] = 0.
        coordsystemmatrix[3,3] = 0.
        coordsystemmatrix[1,2] = 1.
        coordsystemmatrix[2,3] = 1.
        coordsystemmatrix[3,1] = 1.
    end

    # if directionview == "+"
    #     continue
    if directionview == '-'
        R = [-1. 0 0; 0 1. 0; 0 0 -1]
        coordsystemmatrix = R*coordsystemmatrix
    end
	#TODO: controlla se è la trasposto o no
    return coordsystemmatrix*UCS[1:3,1:3]
end


"""
initialize raster image.
"""
function initrasterarray(coordsystemmatrix::Array{Float64,2}, GSD::Float64, model::Lar.LAR)

	verts,edges,faces = model
	bbglobalextention = zeros(2)
	ref = zeros(2)

	newcoord = coordsystemmatrix*verts

	for i in 1:2
		extr = extrema(newcoord[i,:])
		bbglobalextention[i] = extr[2]-extr[1]
		ref[i] = extr[i]
	end

	# IMAGE RESOLUTION
	resX = map(Int∘trunc,bbglobalextention[1] / GSD) + 1
	resY = map(Int∘trunc,bbglobalextention[2] / GSD) + 1

	# Z-BUFFER MATRIX
	rasterquote = fill(-Inf,(resY,resX))

	# RASTER IMAGE MATRIX
	rasterChannels = 3

	RGBtensor = fill(1.,(rasterChannels,resY, resX))

	# refX=ref[1]
	# refY=ref[2]
	return RGBtensor, rasterquote, ref[1], ref[2]
end



"""
Initialize usefull parameters.
"""
function initparams(
	txtpotreedirs::String,
	outputimage::String,
	bbin::Union{String,Tuple{Array{Float64,2},Array{Float64,2}}},
	GSD::Float64,
	PO::String,
	quota::Union{Float64,Nothing},
	thickness::Union{Float64,Nothing},
	ucs::Union{Nothing,String},
	pc::Bool
	)

	# check validity
	@assert isfile(txtpotreedirs) "orthoprojectionimage: $txtpotreedirs not an existing file"
	@assert length(PO)==3 "orthoprojectionimage: $PO not valid view"


	outputfile = splitext(outputimage)[1]*".las"

	potreedirs = PointClouds.getdirectories(txtpotreedirs)
	model = PointClouds.getmodel(bbin)

	if isnothing(ucs)
		coordsystemmatrix = PointClouds.string2matrix(PO)
	else
		UCS = PointClouds.ucsJSON2matrix(ucs)
		coordsystemmatrix = PointClouds.string2matrix(PO,UCS)
	end


	if !isnothing(quota)
		if PO == "XY+" || PO == "XY-"
			puntoquota = [0,0,quota]
		elseif PO == "XZ+" || PO == "XZ-"
			puntoquota = [0, quota, 0]
		elseif PO == "YZ+" || PO == "YZ-"
			puntoquota = [quota, 0, 0]
		end

		@assert !isnothing(thickness) "orthoprojectionimage: thickness missing"
		q_l = (coordsystemmatrix*puntoquota)[3] - thickness/2
		q_u = (coordsystemmatrix*puntoquota)[3] + thickness/2
	else
		q_l = -Inf
		q_u = Inf
	end

	RGBtensor, rasterquote, refX, refY = PointClouds.initrasterarray(coordsystemmatrix,GSD,model)

	aabb = Lar.boundingbox(model[1])
	mainHeader = newHeader(aabb,"ORTHOPHOTO",SIZE_DATARECORD)
	# TODO salvataggio del BB del volume in formato json o ascii da rimettere

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
					 q_l,
					 q_u,
					 pc,
					 ucs,
					 mainHeader)
end
