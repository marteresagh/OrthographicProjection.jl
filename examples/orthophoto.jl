using OrthographicProjection
using FileManager
using Common

txtpotreedirs = "C:/Users/marte/Documents/GEOWEB/wrapper_file/directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
#bbin = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\orthoCAVA\\volume.json"
ucs = Matrix{Float64}(Lar.I,3,3)
GSD = 0.3
PO = "XY+"
quota = nothing #458277.430, 4493982.030, 210.840
thickness = nothing
outputimage = "C:/Users/marte/Documents/GEOWEB/TEST/ortho_prova.jpg"
pc = true
background = [0.0,0.0,0.0]
@time OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, background, pc )
#458117.67 4.49376852e6 208.67 458452.44 4.49417179e6 212.5


# prova
# julia orthophoto.jl "C:/Users/marte/Documents/GEOWEB/FilePotree/orthoCONTEA/directory.txt" -o "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\orthoCONTEA\\Sezione_z650.jpg" --bbin "-0.20750000000000002 -0.792 -0.1865 51.6465 61.4555 12.5555" --bgcolor "0 0 0" --gsd 0.02
