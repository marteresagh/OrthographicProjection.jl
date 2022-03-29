using FileManager
using Visualization
using Common
using OrthographicProjection
import OrthographicProjection.Images

# should output 0.33 0.66 0.00 0.750
mix = OrthographicProjection.blendColors(
    [0, 0, 0, 0],
    [1, 1, 1, 0],
    [1, 0, 0, .5],
    [0, 1, 0, .5]
)



img = fill(
    Images.RGBA(mix...),
    (200, 200),
)
Images.save("transparent4.jpg", img)
