using OrthographicProjection
using FileManager
using Common

txtpotreedirs = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
bbin = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\cava.json"
coordsystemmatrix = Matrix{Float64}(Lar.I,3,3)
GSD = 0.3
PO = "XY+"
outputimage = "examples/Projection_CAVA_$PO.las"

@time OrthographicProjection.pointExtraction(txtpotreedirs, outputimage, coordsystemmatrix, bbin, nothing, nothing )
