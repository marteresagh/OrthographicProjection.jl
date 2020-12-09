using OrthographicProjection
using FileManager
using Common
# using Visualization

txtpotreedirs = "C:/Users/marte/Documents/potreeDirectory/pointclouds/CAVA" #"C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt"
potreedirs = OrthographicProjection.get_potree_dirs(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
output = "C:/Users/marte/Documents/GEOWEB/TEST/SEGMENT/CAVA_Segment.las"
bbin = metadata.tightBoundingBox
bbin = "C://Users//marte//Documents//GEOWEB//FilePotree//orthoCAVA//volume.json"
bbin = Volume([200., 200., 200.], [458309.223, 4493974.624, 199.400], [0.000, 0.000, 0.000])
model = getmodel(bbin)

@time OrthographicProjection.segment(txtpotreedirs, output, model)
