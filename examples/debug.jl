using FileManager
using Visualization
using Common
using OrthographicProjection


source = "C:/Users/marte/Documents/potreeDirectory/pointclouds/CASTELFERRETTI"
json = "C:/Users/marte/Documents/GEOWEB/wrapper_file/JSON/volume_CASTELFERRETTI.json"

model = getmodel(json)
# PC = FileManager.source2pc(source,0)
aabb = AABB(108.553,-45.995,76.484,-78.06400000000001,150.082,-4.466)
model = getmodel(aabb)
GL.VIEW([
	Visualization.points(PC.coordinates,PC.rgbs),
	Visualization.points(center),
	GL.GLGrid(model[1],model[2]),
	Visualization.axis_helper()...
])
