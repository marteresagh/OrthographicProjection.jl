using OrthographicProjection
using FileManager
using Common

txtpotreedirs = "C:/Users/marte/Documents/potreeDirectory/pointclouds/LACONTEA" #"C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt"
potreedirs = OrthographicProjection.get_potree_dirs(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
ucs = Matrix{Float64}(Lar.I,3,3)
GSD = 0.03
PO = "XY+"
quota = 2.50 #458277.430, 4493982.030, 210.840
thickness = 0.05
outputimage = "C:/Users/marte/Documents/GEOWEB/TEST/ORTHO/corner.jpg"
pc = false
background = [0.0,0.0,0.0]
@time OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, background, pc)


## VIEW
# using Visualization
# source = ""
# files = FileManager.get_files_in_potree_folder(source,0)
# PC = FileManager.las2pointcloud(files...)
# V,EV,FV = getmodel(bbin)
#
# GL.VIEW(
#     [
#     GL.GLGrid(V,EV),
#     Visualization.points_color_from_rgb(PC.coordinates,PC.rgbs)
#     ]
# )
