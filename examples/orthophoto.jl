using OrthographicProjection
using FileManager
using Common

txtpotreedirs = "C:/Users/marte/Documents/GEOWEB/FilePotree/orthoCONTEA/directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
#bbin = metadata.tightBoundingBox
#bbin = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\orthoCAVA\\volume.json"
ucs = Matrix{Float64}(Lar.I,3,3)
GSD = 0.3
PO = "XY+"
quota = 2.50 #458277.430, 4493982.030, 210.840
thickness = 0.05
outputimage = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\orthoCONTEA\\Sezione_$quota.jpg"
pc = true

@time OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, pc )
#458117.67 4.49376852e6 208.67 458452.44 4.49417179e6 212.5
