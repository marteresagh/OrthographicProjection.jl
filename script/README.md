# Script Usage

## orthophoto.jl

Orthographic projection of 3D point cloud.

Options:

```
$ julia orthophoto.jl -h   

positional arguments:
  source                A text file with Potree directory list

optional arguments:
  -o, --output OUTPUT   Output image
  --bbin BBIN           Bounding box as 'x_min y_min z_min x_max y_max
                        z_max' or Potree JSON volume model
  --po PO               Orthographic projection: XY+, XY-, XZ+, XZ-,
                        YZ+, YZ- (default: "XY+")
  --gsd GSD             Resolution (type: Float64, default: 0.3)
  --quote QUOTE         Distance of plane from origin (type: Float64)
  --thickness THICKNESS
                        Section thickness (type: Float64)
  --pc                  If true a pc of extracted model is saved in a
                        LAS file
  --bgcolor BGCOLOR     Background color
  -h, --help            show this help message and exit
```

Examples:

    # Orthographic projection of top view
    julia orthophoto.jl C:/Potree_projects.txt -o C:/image.jpg --bbin "0 0 0 1 1 1" --bgcolor "0 0 0"
