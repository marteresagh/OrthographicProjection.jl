using OrthographicProjection
using FileManager
using Common
# using Visualization

txtpotreedirs = "C:/Users/marte/Documents/potreeDirectory/pointclouds/MONTE_VETTORE" #"C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt"
potreedirs = OrthographicProjection.get_potree_dirs(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
ucs = Matrix{Float64}(Lar.I,3,3)
GSD = 0.3
PO = "XZ+"
quota = (bbin.y_max+bbin.y_min)/2 #458277.430, 4493982.030, 210.840
thickness = 1.
outputimage = "C:/Users/marte/Documents/GEOWEB/TEST/ORTHO/MONTE_VETTORE_AABB.jpg"
pc = true
background = [0.0,0.0,0.0]
@time OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, background, pc)
