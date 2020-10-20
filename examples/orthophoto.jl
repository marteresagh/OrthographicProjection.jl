using OrthographicProjection
using FileManager
using Common

txtpotreedirs = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\orthoCAVA\\directory.txt"
potreedirs = FileManager.get_directories(txtpotreedirs)
metadata = CloudMetadata(potreedirs[1])
bbin = metadata.tightBoundingBox
bbin = Common.return_AABB([458117.67, 4.49376852e6, 208.67], [458452.44, 4.49417179e6, 212.5])
#bbin = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\orthoCAVA\\volume.json"
ucs = Matrix{Float64}(Lar.I,3,3)
GSD = 0.3
PO = "XY+"
quota = nothing #458277.430, 4493982.030, 210.840
thickness = nothing
outputimage = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\orthoCAVA\\Projection_CAVA_$PO.jpg"
pc = true
#ucs = Lar.r(0,0,pi/2)[1:3,1:3]
@time OrthographicProjection.orthophoto(txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness, ucs, pc )

bbin = Common.return_AABB(([458117.67, 4.49376852e6, 208.67], [458452.44, 4.49417179e6, 212.5]))
