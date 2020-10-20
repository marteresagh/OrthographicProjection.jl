using OrthographicProjection
using FileManager
using Common

txtpotreedirs = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\orthoCAVA\\directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
#bbin = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\cava.json"
coordsystemmatrix = Matrix{Float64}(Lar.I,3,3)
output = "examples/Extraction_CAVA.las"
quota = 210.
thickness = 2.

@time OrthographicProjection.pointExtraction(txtpotreedirs, output, coordsystemmatrix, bbin, quota, thickness )
