using FileManager
using Visualization
using Common
using OrthographicProjection
import OrthographicProjection.Images
base = [69/255, 109/255, 160/255, 1]
added = [61/255, 47/255, 82/255, 0.8]

mix = [0,0,0,0];
mix[4] = 1 - (1 - added[4]) * (1 - base[4]); # alpha
mix[1] = Common.round((added[1] * added[4] / mix[4]) + (base[1] * base[4] * (1 - added[4]) / mix[4])) # red
mix[2] = Common.round((added[2] * added[4] / mix[4]) + (base[2] * base[4] * (1 - added[4]) / mix[4])) # green
mix[3] = Common.round((added[3] * added[4] / mix[4]) + (base[3] * base[4] * (1 - added[4]) / mix[4])) # blue
# RASTER IMAGE MATRIX
rasterChannels = 4
BGcolor = [69, 109, 160, 1];

img = fill(Images.RGBA(added...), (200,200))
Images.save("transparent.png", img)

Images.RGBA(mix...)



function blendColors(colors...)
    base = [0, 0, 0, 0];
    mix = nothing
    added = nothing
    while (added = args.shift()) {
        if (typeof added[3] === 'undefined') {
            added[3] = 1;
        }
        // check if both alpha channels exist.
        if (base[3] && added[3]) {
            mix = [0, 0, 0, 0];
            // alpha
            mix[3] = 1 - (1 - added[3]) * (1 - base[3]);
            // red
            mix[0] = Math.round((added[0] * added[3] / mix[3]) + (base[0] * base[3] * (1 - added[3]) / mix[3]));
            // green
            mix[1] = Math.round((added[1] * added[3] / mix[3]) + (base[1] * base[3] * (1 - added[3]) / mix[3]));
            // blue
            mix[2] = Math.round((added[2] * added[3] / mix[3]) + (base[2] * base[3] * (1 - added[3]) / mix[3]));

        } else if (added) {
            mix = added;
        } else {
            mix = base;
        }
        base = mix;
    }

    return mix
end
