using OrthographicProjection
using FileManager
using Common
# using Visualization

txtpotreedirs = raw"C:\Users\marte\Downloads\point-cloud-private" #"C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt"
potreedirs = OrthographicProjection.get_potree_dirs(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
output = raw"C:\Users\marte\Downloads\point-cloud-private.las"
bbin = metadata.tightBoundingBox
#bbin = "C:/Users/marte/Documents/GEOWEB/wrapper_file/JSON/volume_COLOMBELLA.json"
# bbin = Volume([200., 200., 200.], [458309.223, 4493974.624, 199.400], [0.000, 0.000, 0.000])
bbin = Volume([37.332, 31.454, 30.835],[295485.136, 4781263.156, 285.114],[0.000, 0.000, -0.685])
model = getmodel(bbin)
epsg = nothing #2049
@time OrthographicProjection.segment(txtpotreedirs, output, model; epsg = epsg)
