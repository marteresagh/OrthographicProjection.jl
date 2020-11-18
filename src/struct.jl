mutable struct ParametersExtraction
	outputfile::String
	potreedirs::Array{String,1}
	coordsystemmatrix::Array{Float64,2}
	model::Lar.LAR
	mainHeader::LasIO.LasHeader
end

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
    mainHeader::LasIO.LasHeader
end
