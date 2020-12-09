using FileManager
using Visualization
using Common
using OrthographicProjection

source = "C:/Users/marte/Documents/potreeDirectory/pointclouds/MONTE_VETTORE"
files = FileManager.get_files_in_potree_folder(source,0)
PC = FileManager.las2pointcloud(files...)

fname = "C:/Users/marte/Documents/GEOWEB/TEST/ORTHO/MONTE_VETTORE_AABB.las"
aabb = FileManager.las2aabb(fname)

V,EV,FV = getmodel(aabb)

GL.VIEW(
    [
    GL.GLGrid(V,EV),
    Visualization.points_color_from_rgb(PC.coordinates,PC.rgbs)
    ]
)
