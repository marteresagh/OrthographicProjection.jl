using OrthographicProjection
using FileManager
using Common

txtpotreedirs = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
bbin = "C:/Users/marte/Documents/FilePotree/cava.json"

GSD = 0.3
PO = "XY+"
outputimage = "examples/Projection_CAVA_$PO.jpg"
@time OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, nothing, nothing, Lar. )
