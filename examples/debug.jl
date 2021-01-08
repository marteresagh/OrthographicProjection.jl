using FileManager
using Visualization
using Common
using OrthographicProjection

source = "C:/Users/marte/Documents/potreeDirectory/pointclouds/CAVA"
files = FileManager.get_files_in_potree_folder(source,0)
PC = FileManager.las2pointcloud(files...)

fname = "C:/Users/marte/Documents/GEOWEB/TEST/SEGMENT/JSONFILE.las"
PC = FileManager.las2pointcloud(fname)
aabb = FileManager.las2aabb(fname)

V,EV,FV = getmodel(aabb)

GL.VIEW(
    [
    GL.GLGrid(V,EV),
    Visualization.points_color_from_rgb(PC.coordinates,PC.rgbs)
    ]
)

# DEBUG
# params = OrthographicProjection.init( txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, background, pc);

# all_files = FileManager.get_files_in_potree_folder(potreedirs[1],0, true)
# PC = FileManager.las2pointcloud(all_files...)
# point cloud
# GL.VIEW(
#     [
#     GL.GLGrid(V,EV),
# 	Visualization.points_color_from_rgb(PC.coordinates,PC.rgbs)
#     ]
# )
