"""
ParametersExtraction

Description:
 - outputfile: Output filename for point cloud
 - potreedirs: Potree projects
 - model: Cuboidal LAR model
 - mainHeader: header of point cloud file las

# Fields
```jldoctest
outputfile::String
potreedirs::Array{String,1}
model::Lar.LAR
mainHeader::LasIO.LasHeader
```
"""
mutable struct ParametersExtraction
	outputfile::String
	potreedirs::Array{String,1}
	model::Lar.LAR
	header_bb::AABB
	mainHeader::LasIO.LasHeader
end


"""
	init(txtpotreedirs::String,
		outputfile::String,
		model::Lar.LAR;
		epsg = nothing::Union{Nothing,Integer}
		)

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
		FileManager.LasIO.epsg_code!(mainHeader, epsg)
	end

	return ParametersExtraction(outputfile,
	potreedirs,
	model,
	AABB(-Inf, Inf,-Inf, Inf,-Inf, Inf),
	mainHeader)
end


"""
ParametersOrthophoto

Description:
 - PO: Projection plane and sight direction. Option: "XY+","XY-","XZ+","XZ-","YZ+","YZ-"
 - outputimage: Output filename for image
 - outputfile: Output filename for point cloud
 - potreedirs: Potree projects
 - model: Cuboidal LAR model
 - coordsystemmatrix: Rotation matrix related to PO
 - RGBtensor: Image tensor
 - rasterquote: Matrix of heigth (z-buffer)
 - GSD: Ground sampling distance
 - refX: x coordinate of landmark
 - refY: y coordinate of landmark
 - pc: if true extract point cloud
 - ucs: user coordinate system
 - mainHeader: header of point cloud file las

# Fields
```jldoctest
PO::String
outputimage::String
outputfile::String
potreedirs::Array{String,1}
model::Lar.LAR
coordsystemmatrix::Array{Float64,2}
RGBtensor::Array{Float64,3}
rasterquote::Array{Float64,2}
GSD::Float64
refX::Float64
refY::Float64
pc::Bool
ucs::Matrix
mainHeader::LasIO.LasHeader
```
"""
mutable struct ParametersOrthophoto
    PO::String
    outputimage::String
    outputfile::String
    potreedirs::Array{String,1}
    model::Lar.LAR
    coordsystemmatrix::Array{Float64,2}
    RGBtensor::Array{Float64,3}
    rasterquote::Array{Float64,2}
    GSD::Float64
    refX::Float64
    refY::Float64
    pc::Bool
    ucs::Matrix
	header_bb::AABB
    mainHeader::LasIO.LasHeader
end

"""
	init(
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
		aabb = Common.boundingbox(model[1])
	end


	RGBtensor, rasterquote, refX, refY = init_raster_array(coordsystemmatrix, GSD, model, BGcolor)

	mainHeader = FileManager.newHeader(aabb,"ORTHOPHOTO",SIZE_DATARECORD)

	return ParametersOrthophoto(PO,
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
					 AABB(-Inf, Inf,-Inf, Inf,-Inf, Inf),
					 mainHeader)
end
