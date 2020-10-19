using FileManager
using Visualization #aggiorna
using Common
using OrthographicProjection


fname = "C:\\Users\\marte\\Documents\\potreeDirectory\\pointclouds\\CAVA"
all_files = FileManager.get_files_in_potree_folder(fname,0)
PC = FileManager.las2pointcloud(all_files...)

GL.VIEW(
    [
    Visualization.points_color_from_rgb(PC.coordinates,PC.rgbs)
    ]
)


txtpotreedirs = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
PO = "YZ+"
quota = 458261.108 #218.047
thickness = 7.76

model = getmodel(bbin)
aabb = Common.boundingbox(model[1])
