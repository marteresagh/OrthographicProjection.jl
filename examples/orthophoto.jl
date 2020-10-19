using OrthographicProjection
using FileManager
using Common

txtpotreedirs = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
#bbin = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\cava.json"
ucs = Matrix{Float64}(Lar.I,3,3)
GSD = 0.3
PO = "YZ+"
quota = 458277.68#218.047
thickness = 7.76
outputimage = "examples/Projection_CAVA_$PO.jpg"

@time OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, true )
