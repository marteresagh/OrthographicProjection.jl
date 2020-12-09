using FileManager
using Visualization
using Common
using OrthographicProjection

source = "C:/Users/marte/Documents/potreeDirectory/pointclouds/CAVA"
files = FileManager.get_files_in_potree_folder(source,1)
PC = FileManager.las2pointcloud(files...)

fname = "C:/Users/marte/Documents/GEOWEB/TEST/ORTHO/CAVA_AABB.las"
aabb = FileManager.las2aabb(fname)

V,EV,FV = getmodel(aabb)

GL.VIEW(
    [
    GL.GLGrid(V,EV),
    Visualization.points_color_from_rgb(PC.coordinates,PC.rgbs)
    ]
)
