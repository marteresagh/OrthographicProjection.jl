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
	mainHeader::LasIO.LasHeader
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
    mainHeader::LasIO.LasHeader
end
