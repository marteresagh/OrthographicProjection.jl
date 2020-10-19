using OrthographicProjection
using FileManager
txtpotreedirs = "C:/Users/marte/Documents/FilePotree/directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
bbin = "C:/Users/marte/Documents/FilePotree/cava.json"

GSD = 0.3
PO = "XY+"
outputimage = "prova$PO.jpg"
@time PointClouds.orthoprojectionimage(txtpotreedirs, outputimage, bbin, GSD, PO, nothing, nothing )
