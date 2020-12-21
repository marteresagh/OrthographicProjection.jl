using OrthographicProjection
using FileManager
using Common
# using Visualization

txtpotreedirs = "C:/Users/marte/Documents/potreeDirectory/pointclouds/CASALETTO" #"C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt"
potreedirs = OrthographicProjection.get_potree_dirs(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
ucs = Matrix{Float64}(Lar.I,3,3)
GSD = 0.03
PO = "XY+"
quota = 105. #458277.430, 4493982.030, 210.840
thickness = 0.05
outputimage = "C:/Users/marte/Documents/GEOWEB/TEST/ORTHO/casaletto_planimetria.jpg"
pc = true
background = [1.0,1.0,1.0]
@time OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, background, pc)
