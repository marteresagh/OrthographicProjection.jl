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
PO = "XZ+"
quota = (bbin.y_max+bbin.y_min)/2 #458277.430, 4493982.030, 210.840
thickness = 1.
outputimage = "C:/Users/marte/Documents/GEOWEB/TEST/ORTHO/CAVA_AABB.jpg"
pc = true
background = [0.0,0.0,0.0]
@time OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, background, pc)


# DEBUG il problema è quando model è un piano che nell'approssimazione mi mangia dei valori.
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
