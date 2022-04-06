using FileManager
using Visualization
using Common
using OrthographicProjection
import OrthographicProjection.Images


mix = OrthographicProjection.blendColors(
    [0.2, 0.2, 0.2, 0.2],
    [0.2, 0.2, 0.2, 0.2],
    [0.2, 0.2, 0.2, 0.2],
    [0.2, 0.2, 0.2, 0.2],
)



img = fill(
    Images.RGBA(mix...),
    (200, 200),
)


Images.save("transparent4.png", img)
