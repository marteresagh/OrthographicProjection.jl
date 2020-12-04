using OrthographicProjection
using FileManager
using Common
# using Visualization

txtpotreedirs = "C:/Users/marte/Documents/potreeDirectory/pointclouds/CAVA" #"C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt"
potreedirs = OrthographicProjection.get_potree_dirs(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
#bbin = "C://Users//marte//Documents//GEOWEB//FilePotree//orthoCAVA//volume.json"
ucs = Matrix{Float64}(Lar.I,3,3)
GSD = 0.3
PO = "XY-"
quota = 210. #458277.430, 4493982.030, 210.840
thickness = 1.
outputimage = "C:/Users/marte/Documents/GEOWEB/TEST/PROVAVISTANEG.jpg"
pc = true
background = [0.0,0.0,0.0]
@time OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, background, pc)

# params = OrthographicProjection.init( txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, background, pc);
#
# all_files = FileManager.get_files_in_potree_folder(potreedirs[1],0, true)
# PC = FileManager.las2pointcloud(all_files...)
#
# V,EV,FV = params.model
# # point cloud
# GL.VIEW(
#     [
#     GL.GLGrid(V,EV),
#     Visualization.points_color_from_rgb(PC.coordinates,PC.rgbs)
#     ]
# )
